
# install psycopg2 (if needed)
# pip3 install psycopg2    # (or pip)

# https://www.pg4e.com/code/simple.py

# https://www.pg4e.com/code/hidden-dist.py
# copy hidden-dist.py to hidden.py
# edit hidden.py and put in your credentials

# python3 simple.py

# To check the results, use psql and look at the
# pythonfun table

import psycopg2
import hidden

# Load the secrets
secrets = hidden.secrets()

conn = psycopg2.connect(host=secrets['host'],
        port=secrets['port'],
        database=secrets['database'], 
        user=secrets['user'], 
        password=secrets['pass'], 
        connect_timeout=3)

cur = conn.cursor()

sql = 'DROP TABLE IF EXISTS pythonseq CASCADE;'
print(sql)
cur.execute(sql)

sql = 'CREATE TABLE pythonseq (iter INTEGER, val INTEGER);'
print(sql)
cur.execute(sql)

conn.commit()    # Flush it all to the DB server

number = 290724
for i in range(300) :
    sql = 'INSERT INTO pythonseq(iter, val) VALUES (%s, %s)'
    cur.execute(sql, (i,number, ))
    if i % 50 ==0:
        print(i+1, number)
    number = int((number * 22) / 7) % 1000000

conn.commit()

sql = "SELECT iter,val  FROM pythonseq WHERE iter=5;" 
print(sql)
cur.execute(sql)

row = cur.fetchone()
if row is None : 
    print('Row not found')
else:
    print('Found', row)

conn.commit()
cur.close()

