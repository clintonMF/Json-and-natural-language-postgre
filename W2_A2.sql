-- GIN ts_vector Index

-- In this assignment, you will create a table of documents and then produce a GIN-based ts_vector index on the documents.

DROP TABLE docs03 CASCADE;
CREATE TABLE docs03 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE INDEX fulltext03 ON docs03 USING gin(to_tsvector('english', doc));

INSERT INTO docs03 (doc) VALUES
('problem youre seeing What did you change last before the problem'),
('changes until you get back to a program that works and that you'),
('understand Then you can start rebuilding'),
('Beginning programmers sometimes get stuck on one of these activities and'),
('For example reading your code might help if the problem is a'),
('typographical error but not if the problem is a conceptual'),
('misunderstanding If you dont understand what your program does you'),
('can read it 100 times and never see the error because the error is in'),
('Running experiments can help especially if you run small simple tests'),
('But if you run experiments without thinking or reading your code you');
-- You should also insert a number of filler rows into the table to make sure PostgreSQL uses its index:

INSERT INTO docs03 (doc) SELECT 'Neon ' || generate_series(10000,20000);

EXPLAIN SELECT id, doc FROM docs03 WHERE to_tsquery('english', 'instructions') @@ to_tsvector('english', doc);