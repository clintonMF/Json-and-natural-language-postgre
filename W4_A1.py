
import psycopg2
import hidden
import time
import myutils
import requests
import json
import sys

# Load the secrets
secrets = hidden.secrets()

conn = psycopg2.connect(host=secrets['host'],
        port=secrets['port'],
        database=secrets['database'],
        user=secrets['user'],
        password=secrets['pass'],
        connect_timeout=30)

cur = conn.cursor()

sql = '''
CREATE TABLE IF NOT EXISTS pokeapi (id INTEGER, body JSONB);
'''
print(sql)
cur.execute(sql)
conn.commit()

for i in range(1, 101):
    try:
        api_url = f'https://pokeapi.co/api/v2/pokemon-species/{i}'
        r = requests.get(api_url)
        body = r.text
        
        sql = 'INSERT INTO pokeapi (id, body) VALUES ( %s, %s );'
        cur.execute(sql, (i, body, ))
        if i % 10 == 0:
            conn.commit()
            print(f"i have added the json file for url ending in {i}")
    except KeyboardInterrupt:
        print('')
        print('Program interrupted by user...')
        break
    except Exception as e:
        print("Unable to retrieve or parse page",api_url)
        print("Error",e)
        fail = fail + 1
        if fail > 5 : break
        continue

sql = "SELECT id, body  FROM pokeapi WHERE id=50;" 
print(sql)
cur.execute(sql)

row = cur.fetchone()
if row is None : 
    print('Row not found')
else:
    print('Found', row)

    
print('Closing database connection...')
conn.commit()
cur.close()