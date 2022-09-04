// import * as IPFS from "ipfs-core";
import * as IpfsClient from "ipfs-http-client";
// import * as IPFS from "ipfs";
import { createRequire } from "module";
const require = createRequire(import.meta.url);

const { Kafka } = require("kafkajs");
const OrbitDB = require("orbit-db");

const kafka = new Kafka({
  clientId: "ipiva-client",
  brokers: ["localhost:9092"],
});

const consumer = kafka.consumer({ groupId: "ipiva-group" });

const run = async () => {
  const ipfs = await IpfsClient.create("/ip4/0.0.0.0/tcp/5001")

  const orbitdb = await OrbitDB.createInstance(ipfs);
  const options = {
    // Give write access to ourselves
    accessController: {
      write: [orbitdb.identity.id]
    }
  }
  const db = await orbitdb.log("ipiva", options);
  const address = db.address;
  console.log("Orbit-db: ", address);
  console.log("Orbit-db address string: ", address.toString());

  await db.load();

  await consumer.connect();
  await consumer.subscribe({ topic: "metadata", fromBeginning: true });

    // When the second database replicated new heads, query the database
  db.events.on('replicated', () => {
      const result = db.iterator({ limit: -1 }).collect().map(e => e.payload.value)
      console.log(result)
    })

    await consumer.run({
      
      eachMessage: async ({ topic, partition, message }) => {
        const hash = await db.add(message.value.toString())
        console.log(`Metadata saved to Orbit-db: ${hash}`)
      },
    })
  
};

run().catch(console.error);
