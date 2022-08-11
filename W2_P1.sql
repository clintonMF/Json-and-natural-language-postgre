DROP TABLE docs;
CREATE TABLE docs (
    id SERIAL PRIMARY KEY,
    doc TEXT
);

-- creating gin index
CREATE INDEX gin1 on docs using GIN(string_to_array(doc, ' ') array_ops);

-- insert values into docs
INSERT INTO docs (doc) VALUES
('This is SQL and Python and other fun teaching stuff'),
('More people should learn SQL from UMSI'),
('UMSI also teaches Python and also SQL');

-- adding extra values to make sure
-- this is done to ensure that the inverted index is used
INSERT INTO docs(doc) select 'NEON ' || generate_series(10000, 20000);

-- wait a while for the index to be created
select id, doc from docs where '{learn}' <@ string_to_array(doc, ' ');
-- the "<@" sign means contains

EXPLAIN ANALYZE select id, doc from docs where '{learn}' <@ string_to_array(doc, ' ');

