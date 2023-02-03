package main

import (
	"context"
	"os"
	"time"

	"github.com/edgedb/edgedb-go"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

type Inserted struct {
	Id edgedb.UUID `edgedb:"id"`
}

func getEdgeDbClient() *edgedb.Client {
	edgeDbDSN := os.Getenv("EDGEDB_DSN")
	client, err := edgedb.CreateClientDSN(nil, edgeDbDSN, edgedb.Options{})
	if err != nil {
		log.Error().Err(err).Msg("Error connecting to EdgeDB")
		os.Exit(1)
	}

	return client
}

func insertData(client *edgedb.Client) (*Inserted, error) {
	insertQuery := `
	INSERT InsertTest {
		timestamp := <datetime>$0,
		source := <str>$1
	}`

	var inserted Inserted
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	err := client.QuerySingle(
		ctx,
		insertQuery,
		&inserted,
		time.Now().UTC(),
		"go-test")

	if err != nil {
		return nil, err
	}

	return &inserted, nil
}

func main() {
	zerolog.TimeFieldFormat = time.RFC3339Nano
	zerolog.SetGlobalLevel(zerolog.TraceLevel)
	log.Logger = log.Output(
		zerolog.ConsoleWriter{Out: os.Stdout, TimeFormat: time.RFC3339Nano},
	)

	dbClient := getEdgeDbClient()
	defer dbClient.Close()

	for {
		inserted, err := insertData(dbClient)
		if err != nil {
			log.Error().Err(err).Msg("error inserting data")
		}
		log.Info().Interface("inserted", inserted).Msg("inserted data")
		time.Sleep(5 * time.Second)
	}
}
