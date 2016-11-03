import csv
from pg import DB
import sys


db = DB(dbname='test', host='127.0.0.1', port=5432, user='test', passwd='1')
def outfit():
    with open('outfit.csv', 'rb') as f:
        content = csv.reader(f)
        content.next()
        content.next()
        for row in content:

            if row[6] is '':
                row[6] = 0
            if row[7] is '':
                row[7] = ''
            if row[8] is '':
                row[8] = 0

            sendDict = {
              "effect": row[6],
              "type": row[7],
              "isFull": row[8]
            }
            db.insert('outfit', name=row[1].decode('utf-8'),
                                strength=row[2].decode('utf-8'),
                                armor=row[3].decode('utf-8'),
                                damage=row[4].decode('utf-8'),
                                cdamage=row[5].decode('utf-8'),
                                params=sendDict
                                )
def resource(file):
    with open(str(file) + '.csv', 'rb') as f:
        content = csv.reader(f)
        content.next()
        for row in content:
            try:
                db.insert(str(file), name=row[1].decode('utf-8'))
            except Exception:
                print 'Out of range'
                db.insert(str(file), name=row[0].decode('utf-8'))
            finally:
                print 'ok'

def cards():
    with open('cards.csv', 'rb') as f:
        content = csv.reader(f)
        #content.next()
        typeDict = ''
        for row in content:
            if row[0] == 'bronse_scrols':
                typeDict = row[0]
                continue
            if row[0] == 'silver_scrols':
                typeDict = row[0]
                continue
            if row[0] == 'gold_scrols':
                typeDict = row[0]
                continue

            if row[0] == '' or row[0] == 'card_name':
                continue

            bdDict = {
                "name": row[0],
                "type": typeDict,
                "abil_1": {
                    "effect_1": row[1],
                    "effect_2": row[2],
                    "reload_time": row[3],
                    "reload_buff": row[4]
                },
                "abil_2": {
                    "effect_1": row[5],
                    "effect_2": row[6],
                    "reload_time": row[7],
                    "reload_buff": row[8]
                },
                "abil_3": {
                    "effect_1": row[9],
                    "effect_2": row[10],
                    "reload_time": row[11],
                    "reload_buff": row[12]
                },
                "abil_4": {
                    "effect_1": row[13],
                    "effect_2": row[14],
                    "reload_time": row[15],
                    "reload_buff": row[16]
                },
                "abil_5_periodic": {
                    "effect_1": row[17],
                    "effect_2": row[18],
                    "reload_time": row[19],
                    "reload_buff": row[20]
                },
                "abil_5_periodic": {
                    "effect_1": row[21],
                    "effect_2": row[22],
                    "reload_time": row[23],
                    "reload_buff": row[24]
                }

            }
            db.insert('cards', params=bdDict)

if __name__ == '__main__':
    arg = sys.argv[1:]
    if arg[0] == 'resources' or arg[0] == 'stuff':
        resource(arg[0])
    elif arg[0] == 'outfit':
        outfit()
    elif arg[0] == 'cards':
        cards()
