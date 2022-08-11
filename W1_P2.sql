/* this practice file focus on the process of stemming
* stemming is the process of linking words that are similar to have
* have a common word in the invert index i.e teaching, teahcer,teach can 
* be a replaced by teach since they have similar meaning.
 */

DROP TABLE docs CASCADE;
CREATE TABLE docs (id SERIAL, doc TEXT, PRIMARY KEY(id));
INSERT INTO docs (doc) VALUES
('This is SQL and Python and other fun teaching stuff'),
('More people should learn SQL from UMSI'),
('UMSI also teaches Python and also SQL');

DROP TABLE docs_gin;
CREATE TABLE docs_gin (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs(id) ON DELETE CASCADE
);


-- ceeating stop words table
DROP TABLE stop_words;
CREATE TABLE stop_words (word TEXT unique);
-- Here are your stop words:
INSERT INTO stop_words (word) VALUES 
('i'), ('a'), ('about'), ('an'), ('are'), ('as'), ('at'), ('be'), 
('by'), ('com'), ('for'), ('from'), ('how'), ('in'), ('is'), ('it'), ('of'), 
('on'), ('or'), ('that'), ('the'), ('this'), ('to'), ('was'), ('what'), 
('when'), ('where'), ('who'), ('will'), ('with');

-- creating the stem table and inserting values into it
DROP TABLE docs_stem;
CREATE TABLE docs_stem (word TEXT, stem TEXT);
INSERT INTO docs_stem (word, stem) VALUES
('teaching', 'teach'), ('teaches', 'teach');

-- checking what we want to stem down 
-- (the stem would be added as third column)
SELECT DISTINCT id, keyword, stem from 
(SELECT DISTINCT id, s.keyword as keyword from 
docs as d, unnest(string_to_array(lower(d.doc), ' ')) s(keyword)
where s.keyword not in (select word from stop_words)) as k
left join docs_stem as ds on k.keyword = ds.word;

-- final check (merging the stem and keyword column)
-- the stem column is favoured ahead of the keyword column
SELECT id,
CASE WHEN stem IS NOT NULL THEN stem ELSE keyword END AS stemkeyword,
stem, keyword FROM
(SELECT id, s.keyword as keyword from 
docs as d, unnest(string_to_array(lower(d.doc), ' ')) s(keyword)
where s.keyword not in (select word from stop_words)) as k
left join docs_stem as ds on k.keyword = ds.word;

-- final check a better way
SELECT id, COALESCE(stem, keyword) as keyword
FROM (SELECT id, s.keyword as keyword from 
docs as d, unnest(string_to_array(lower(d.doc), ' ')) s(keyword)
where s.keyword not in (select word from stop_words)) as k
left join docs_stem as ds on k.keyword = ds.word;


-- inserting the stemmed down words into the inverted index
INSERT INTO docs_gin(doc_id, keyword)
SELECT id, COALESCE(stem, keyword) as keyword
 FROM (SELECT id, s.keyword as keyword from 
docs as d, unnest(string_to_array(lower(d.doc), ' ')) s(keyword)
where s.keyword not in (select word from stop_words)) as k
left join docs_stem as ds on k.keyword = ds.word;

select * from docs_gin;

-- searching for words in the docs
-- * we give preference to the stem words then the keywords

SELECT id, doc FROM docs as d
join docs_gin as dg on d.id = dg.doc_id
WHERE dg.keyword = COALESCE((SELECT stem from docs_stem WHERE word='teaching'),'teaching');
