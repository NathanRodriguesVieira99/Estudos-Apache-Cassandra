export interface DatabaseConnection {
  connect(): Promise<void>;
  query(statement: string, params: any[]): Promise<any>;
  disconnect(): Promise<void>;
}
