-- in this practice file  i will make use of ts_vector and ts_query
-- ts_vector - returns a list of words that represent the documents
-- ts_query - returns a list of words with operations to represent various combinations 
-- of words i.e stemming teaching and teachers can be represented by teach.

-- first i would like to show the raw usecase of ts_vector and ts_query

SELECT to_tsvector('english','This is SQL and Python and other fun teaching stuff');
SELECT to_tsquery('english','teaching');

-- combining both 
SELECT to_tsquery('english', 'teach') @@ 
to_tsvector('english','This is SQL and Python and other fun teaching stuff');
-- the block of code above would give an output "t" which means true
-- the symbol "@@" is an operator used to ask if the to_tsquery matches
-- the to_tsvector.


DROP TABLE docs CASCADE;
CREATE TABLE docs (
    id SERIAL PRIMARY KEY,
    doc TEXT
);
-- creating gin index
CREATE INDEX gin1 on docs using GIN(to_tsvector('english', doc));

-- insert values into docs
INSERT INTO docs (doc) VALUES
('This is SQL and Python and other fun teaching stuff'),
('More people should learn SQL from UMSI'),
('UMSI also teaches Python and also SQL');
lec

select id, doc from docs WHERE to_tsquery('english', 'teach') @@
to_tsvector('english', doc);

EXPLAIN ANALYZE select id, doc from docs WHERE 
to_tsquery('english', 'teach') @@ to_tsvector('english', doc);


-- if you want to create a gist index just replace the gin with a gist
-- e.g
CREATE INDEX gin1 on docs using GIST(to_tsvector('english', doc));

-- GIN is the preffered inverse index. this is due to the fact that 
-- it is better for all sorts of querying.
-- GIST is much better for inserting and updating