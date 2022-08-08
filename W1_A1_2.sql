/* the first assignment was to create the database for the course
the database credentials and passwords were given */

/* the second assignment is to create tables for the autograder and 
result tables */

/* The pg4e_debug table will let you see the queries that were run by the 
auto grader as it is grading your assignment. It is cleared out at the 
beginning of each autograder attempt. */

CREATE TABLE pg4e_debug (
  id SERIAL,
  query VARCHAR(4096),
  result VARCHAR(4096),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
);

--You can view the contents of this table after running the autograder with 
-- this command:

SELECT query, result, created_at FROM pg4e_debug;

CREATE TABLE pg4e_result (
  id SERIAL,
  link_id INTEGER UNIQUE,
  score FLOAT,
  title VARCHAR(4096),
  note VARCHAR(4096),
  debug_log VARCHAR(8192),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

