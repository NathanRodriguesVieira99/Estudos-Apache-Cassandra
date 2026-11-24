import cassandra, { type Client } from "cassandra-driver";
import type { DatabaseConnection } from "./database-connection.ts";

type CassandraOptions = {
  contactPoints: string[];
  localDataCenter: string;
  username: string;
  password: string;
  keyspace: string;
};

export class Cassandra implements DatabaseConnection {
  private readonly client: Client;

  constructor({ contactPoints, localDataCenter, username, password, keyspace }: CassandraOptions) {
    this.client = new cassandra.Client({
      contactPoints,
      localDataCenter,
      credentials: { username, password },
      keyspace,
    });
  }

  async connect(): Promise<void> {
    await this.client.connect();
    console.log("Cassandra conectado");
  }

  async query(cql: string, params: any[]): Promise<any> {
    const result = await this.client.execute(cql, params, { prepare: true });
    return result.rows;
  }

  async disconnect(): Promise<void> {
    await this.client.shutdown();
    console.log("Cassandra desconectado");
  }
}
