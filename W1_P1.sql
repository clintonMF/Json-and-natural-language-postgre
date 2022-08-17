/* this practice file would be on creating an inverted index 
Using lower case and stop words */

--creating the tables

CREATE TABLE docs (
    id SERIAL PRIMARY KEY,
    doc TEXT
);

CREATE TABLE invertdocs (
    keyword TEXT,
    doc_id INTEGER REFERENCES docs(id) ON DELETE CASCADE
);

CREATE TABLE stop_words (
    id SERIAL PRIMARY KEY,
    stop_word TEXT
);

-- insert values messages into the docs table 
INSERT INTO docs(doc) values
('THIS is me trying to makes sense of everything'),
('I have to face reality and make my life better'),
('i know things will get better');

--inserting stop words into stop_words
INSERT INTO stop_words (stop_word) VALUES 
('i'), ('a'), ('about'), ('an'), ('are'), ('as'), ('at'), ('be'), 
('by'), ('com'), ('for'), ('from'), ('how'), ('in'), ('is'), ('it'), ('of'), 
('on'), ('or'), ('that'), ('the'), ('this'), ('to'), ('was'), ('what'), 
('when'), ('where'), ('who'), ('will'), ('with');

--check to see the words you intend to insert into the inverted index table

SELECT DISTINCT id, s.keyword AS keyword 
FROM docs as d, unnest(string_to_array(lower(d.doc), ' ')) s(keyword)
WHERE s.keyword NOT IN (SELECT stop_word FROM stop_words)
ORDER BY id;

-- insert into the inverted index table 
INSERT INTO invertdocs(doc_id,keyword)
SELECT DISTINCT id, s.keyword AS keyword 
FROM docs as d, unnest(string_to_array(lower(d.doc), ' ')) s(keyword) 
WHERE s.keyword NOT IN (SELECT stop_word FROM stop_words);


-- searching for words in the inverted 
-- below is a template to search for the keyword
-- replace the search term with the actual term
SELECT DISTINCT id, doc from docs 
JOIN invertdocs on docs.id = invertdocs.doc_id
where invertdocs.keyword = -- * the search term.;


-- searching for a word in the docs
SELECT id, doc from docs 
JOIN invertdocs on docs.id = invertdocs.doc_id
where invertdocs.keyword = 'reality';

-- searching for stop words
-- this is to ensure we got the procedure right 
SELECT DISTINCT id, doc from docs 
JOIN invertdocs on docs.id = invertdocs.doc_id
where invertdocs.keyword = 'a';
-- if you use a word from the stopword table and records 
-- are returned. please go through the process again 


--seraching for several words in the docs at once
SELECT DISTINCT id, doc from docs 
JOIN invertdocs on docs.id = invertdocs.doc_id
where invertdocs.keyword IN ('reality', 'sense', 'better', 'this');


