import * as edgedb from "edgedb";

const client = edgedb.createClient(process.env.EDGEDB_DSN);

const delay = ms => new Promise(resolve => setTimeout(resolve, ms))


async function insertData() {
    const result = await client.query(`
	INSERT ShellyTRV {
		timestamp := <datetime>$0,
		device := (insert Device { device_id := "js-test-trv" } unless conflict on .device_id else (select Device)),
		battery := <float32>$1,
		position := <float32>$2,
		target_temperature := <float32>$3,
		temperature := <float32>$4
	}`, [
        new Date(),
        47.42,
        42.69,
        23.4,
        21.9
    ]);
    console.log(new Date(), "inserted", result);
}

async function main() {
    while (true) {
        await insertData()
        await delay(5000)
    }
}

main()
