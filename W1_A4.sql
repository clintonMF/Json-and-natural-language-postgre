/* Reverse Index (with stop words) in SQL

In this assignment, you will create a table of document and
then produce a reverse index with stop words for those documents 
that identifies each document which contains a particular word 
using SQL. */

/* Here is a sample for the first few expected rows of your reverse index:

SELECT keyword, doc_id FROM invert02 ORDER BY keyword, doc_id LIMIT 10;

keyword    |  doc_id
-----------+--------
activities |    4    
and        |    2    
and        |    4    
and        |    8    
back       |    2    
because    |    8    
before     |    1    
beginning  |    4    
but        |    6    
but        |    10   
*/

--create tables
CREATE TABLE docs02 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE TABLE invert02 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs02(id) ON DELETE CASCADE
);

-- insert values into the docs02 table
INSERT INTO docs02 (doc) VALUES
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

-- creating the stop words table
CREATE TABLE stop_words (word TEXT unique);

-- Here are your stop words:
INSERT INTO stop_words (word) VALUES 
('i'), ('a'), ('about'), ('an'), ('are'), ('as'), ('at'), ('be'), 
('by'), ('com'), ('for'), ('from'), ('how'), ('in'), ('is'), ('it'), ('of'), 
('on'), ('or'), ('that'), ('the'), ('this'), ('to'), ('was'), ('what'), 
('when'), ('where'), ('who'), ('will'), ('with');

-- looking at the set of words in the docs without the stop words
SELECT DISTINCT id, s.keyword as keyword 
from docs02 as d, unnest(string_to_array(lower(d.doc),' ')) s(keyword)
WHERE s.keyword NOT IN (SELECT word from stop_words)
order by id;

-- insert into invert02
INSERT INTO invert02(doc_id, keyword)
SELECT DISTINCT id, s.keyword as keyword 
from docs02 as d, unnest(string_to_array(lower(d.doc), ' ')) s(keyword)
WHERE s.keyword NOT IN (SELECT word from stop_words)
order by id;

--checking final result
SELECT keyword, doc_id FROM invert02 ORDER BY keyword, doc_id LIMIT 10;

--the table must be equivalent to that at the top; the sample.

