-- String Array GIN Index
-- In this assignment, you will create a table of documents and then produce a GIN-based text[] reverse index for those documents that identifies each document which contains a particular word using SQL.

-- FYI: In contrast with the provided sample SQL, you will map all the words in the GIN index to lower case (i.e. Python, PYTHON, and python should all end up as "python" in the GIN index).


-- The goal of this assignment is to run these queries:

-- SELECT id, doc FROM docs03 WHERE '{misunderstanding}' <@ string_to_array(lower(doc), ' ');
-- EXPLAIN SELECT id, doc FROM docs03 WHERE '{misunderstanding}' <@ string_to_array

-- and (a) get the correct document(s) and (b) use the GIN index (i.e. not use a sequential scan).

CREATE TABLE docs03 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE INDEX array03 ON docs03 USING gin(string_to_array(lower(doc), ' ') array_ops);

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

INSERT INTO docs03(doc) SELECT 'NEON ' || generate_series(10000, 20000);


EXPLAIN SELECT id, doc FROM docs03 WHERE '{misunderstanding}' <@ string_to_array(lower(doc), ' ');