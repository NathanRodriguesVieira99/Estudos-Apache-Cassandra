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

-- Criar um KEYSPACE
CREATE KEYSPACE test_keyspace WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}
                               AND durable_writes = true;

-- Listar KEYSPACES
SELECT *
from system_schema.keyspaces;

-- Apagar KEYSPACE
DROP KEYSPACE test_keyspace;

-- Usar KEYSPACE
USE test_keyspace;

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

-- Buscar na TABELA
SELECT *
FROM test_keyspace.employee_by_id;

SELECT *
FROM test_keyspace.employee_by_car_make;

-- Apagar TABELA
DROP TABLE employee_by_id;
DROP TABLE employee_by_car_make;

