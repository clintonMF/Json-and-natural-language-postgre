
/* Reverse Index in SQL

In this assignment, you will create a table of documents and then produce 
a reverse index for those documents that identifies each document which
 contains a particular word using SQL.

FYI: In contrast with the provided sample SQL, you will map all the words 
in the reverse index to lower case (i.e. Python, PYTHON, and python should
 all end up as "python" in the inverted index). */


-- Here is a sample for the first few expected rows of your reverse index:

/* RESULTS
SELECT keyword, doc_id FROM invert01 ORDER BY keyword, doc_id LIMIT 10;

keyword    |  doc_id
-----------+--------
a          |    2    
a          |    5    
a          |    6    
activities |    4    
and        |    2    
and        |    4    
and        |    8    
back       |    2    
because    |    8    
before     |    1    

*/



-- creating the tables

CREATE TABLE docs01 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE TABLE invert01 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs01(id) ON DELETE CASCADE
);

-- inserting values
INSERT INTO docs01 (doc) VALUES
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

-- check the details you want to input into the invert01 tables
SELECT id, s.keyword as keyword
from docs01 as d, unnest(string_to_array(d.doc, ' ')) s(keyword)
ORDER BY id;

--insert into the table
insert into invert01(doc_id, keyword)
SELECT id, s.keyword as keyword
from docs01 as d, unnest(string_to_array(d.doc, ' ')) s(keyword);

--checking final result
SELECT keyword, doc_id FROM invert01 ORDER BY keyword, doc_id LIMIT 10;

--the table must be equivalent to that at the top; the sample.
