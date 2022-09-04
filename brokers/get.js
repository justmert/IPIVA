// import * as IPFS from "ipfs-core";
import * as IpfsClient from "ipfs-http-client";
// import * as IPFS from "ipfs";
import { createRequire } from "module";
const require = createRequire(import.meta.url);
const OrbitDB = require("orbit-db");

const run = async () => {
    const ipfs = await IpfsClient.create("/ip4/0.0.0.0/tcp/5001")

    const orbitdb = await OrbitDB.createInstance(ipfs);
    const db = await orbitdb.log("ipiva");
    const address = db.address;
    console.log("Orbit-db: ", address);
    console.log("Orbit-db Address: ", address.toString());

    await db.load();
    var args = process.argv.slice(2);
    console.log(args)
    args.forEach(element => {
    const event = db.get(element)
    console.log(`hash: ${event.hash}, metadata: ${event.payload.value}\n`)
    });
    db.close();
    return; 
};

run().catch(console.error);
