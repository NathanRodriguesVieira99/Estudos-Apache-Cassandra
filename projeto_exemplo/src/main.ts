import { randomUUID } from "node:crypto";
import { faker } from "@faker-js/faker";
import { Cassandra } from "./cassandra.ts";

const cassandra = new Cassandra({
  contactPoints: [String(process.env.CASSANDRA_CONTACT_POINTS)],
  localDataCenter: String(process.env.CASSANDRA_DATACENTER),
  username: String(process.env.CASSANDRA_USERNAME),
  password: String(process.env.CASSANDRA_PASSWORD),
  keyspace: String(process.env.CASSANDRA_KEYSPACE),
});

const run = async () => {
  try {
    await cassandra.connect();
    await cassandra.query(
      `CREATE TABLE IF NOT EXISTS professores ( 
      id UUID PRIMARY KEY, 
      nome TEXT, 
      disciplinas TEXT 
      )`,
      [],
    );
    await cassandra.query(`INSERT INTO professores (id,nome,disciplinas) VALUES (?,?,?)`, [
      randomUUID(),
      faker.person.fullName(),
      faker.word.words({ count: { min: 1, max: 3 } }),
    ]);
    const result = await cassandra.query(`SELECT * FROM professores`, []);
    console.log({ result });
  } catch (error) {
    console.error(`ERRO: ${error}`);
  } finally {
    await cassandra.disconnect();
  }
};

run();
