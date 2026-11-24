-- Estudos Apache Cassandra --

-- Bancos de dados NoSQL seguem geralmente o BASE --
-- Basically Available / Basicamente Disponível - sempre disponível.
-- Soft State / Estado Flexível - não garante o estado caso o banco caia e retorne.
-- Eventual Consistency / Consistência Eventual - se os dados estiverem diferentes, uma hora tudo é sincronizado e todos os nós passam a ter os mesmos dados.

-- Bancos de dados relacionais seguem geralmente o ACID --
-- Atomicity / Atomicidade - vai executar a transaction por completo ou falhar tudo.
-- Consistency / Consistência - não permite executar ações que deixariam o estado do banco inconsistente.
-- Isolation / Isolamento - cada transaction roda isoladamente sem interferir uma na outra.
-- Durability / Durabilidade - quando a transaction é commited, o estado persiste mesmo com falhas ou reinicio do banco.

-- Grupos dos bancos NoSQL --

-- Orientados a Colunas
-- Facilmente escaláveis.
-- I/O de disco otimizado.
-- Otimizados para recuperações rápidas de colunas (columns) de dados ao invés de linhas (rows) nos bancos SQL.
-- Exemplo:
-- Cassandra

-- Orientados a Documentos
-- Não possuem schema (schemaless).
-- Permitem redundância e pode haver inconsistências.
-- Exemplo:
-- MongoDB

-- Orientados a Chave-Valor
-- Armazenam dados indexados por chaves.
-- Rodam em memória.
-- Muito rápidos para buscas, geralmente usados para Cache.
-- Exemplo:
-- Redis

-- Orientados a Grafos
-- Utilizados para armazenar grafos.
-- Exemplo:
-- Neo4J

-- Exemplo de caso de uso com o Cassandra --

-- Para armazenar grandes quantidades de dados e fazer relatórios desses dados.

-- CQL ( Cassandra Query Language)
-- Não possui JOIN.


-- Criar um KEYSPACE
CREATE KEYSPACE test_keyspace WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}
                               AND durable_writes = true;

CREATE KEYSPACE banking WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}
                         AND durable_writes = true;

-- Listar KEYSPACES
SELECT *
from system_schema.keyspaces;

-- Apagar KEYSPACE
DROP KEYSPACE test_keyspace;

-- Usar KEYSPACE
USE test_keyspace;

USE banking;

-- Criar TABELA
CREATE TABLE employee_by_id
(
    id       int PRIMARY KEY,
    name     text,
    position text
);

CREATE TABLE employee_by_car_make
(
    car_make  text,
    id        int,
    car_model text,
    PRIMARY KEY ( car_make, id )
);

CREATE TABLE banking.transactions_by_acc
(
    bank_id        text,
    acct_id        text,
    transaction_id UUID,
    description    text,
    amount         decimal,
    ts             timestamp,
    PRIMARY KEY ((bank_id, acct_id), transaction_id ) -- bank_id, acct_id são as chaves de partição
) WITH CLUSTERING ORDER BY (transaction_id DESC); -- transaction_id é a coluna de clusterização

-- No WHERE sempre se dever especificar a(s) chave(s) de partição e pode especificar alguma ou todas as colunas de clusterização

-- Buscar na TABELA
SELECT *
FROM test_keyspace.employee_by_id;

SELECT *
FROM test_keyspace.employee_by_car_make;

SELECT *
FROM banking.transactions_by_acc
LIMIT 5;

-- Apagar TABELA
DROP TABLE employee_by_id;
DROP TABLE employee_by_car_make;

-- Inserir dados na TABELA
INSERT INTO banking.transactions_by_acc (bank_id, acct_id, transaction_id, description, amount, ts)
VALUES ('B001',
        'AC001',
        3955e20c-7311-4b61-ae20-d133fe487813,
        'Debito',
        -100.13,
        '2026-11-24T04:31:10');

-- Atualizar TABELA
UPDATE banking.transactions_by_acc
SET description = 'Debito',
    amount      = -200.12,
    ts = '2026-11-24T05:30:10'
WHERE bank_id = 'B001'
  AND acct_id = 'AC002'
  AND transaction_id = 3955e20c-7311-4b61-ae20-d133fe487813;

-- query com partition keys + clustering key
SELECT *
FROM banking.transactions_by_acc
WHERE bank_id = 'B001'
  AND acct_id = 'AC002'
  AND transaction_id = 3955e20c-7311-4b61-ae20-d133fe487813;

-- query apenas com partition keys
SELECT *
FROM banking.transactions_by_acc
WHERE bank_id = 'B001'
  AND acct_id = 'AC002';