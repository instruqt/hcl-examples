CREATE USER example WITH PASSWORD 'example';
CREATE DATABASE example;
GRANT ALL PRIVILEGES ON DATABASE example TO example;

\c example;
CREATE TABLE example (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

GRANT ALL PRIVILEGES ON TABLE example TO example;

INSERT INTO example (name) VALUES ('first');
INSERT INTO example (name) VALUES ('second');
INSERT INTO example (name) VALUES ('third');
INSERT INTO example (name) VALUES ('fourth');
INSERT INTO example (name) VALUES ('fifth');