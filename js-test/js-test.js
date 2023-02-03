import * as edgedb from "edgedb";

const client = edgedb.createClient(process.env.EDGEDB_DSN);

const delay = ms => new Promise(resolve => setTimeout(resolve, ms))

async function insertData() {
    const result = await client.query(`
	INSERT InsertTest {
		timestamp := <datetime>$0,
		source := <str>$1
	}`, [
        new Date(),
        "js-test"
    ]);
    console.log(result);
}

async function main() {
    while (true) {
        await insertData()
        await delay(5000)
    }
}

main()
