import geojson
import os
import glob
from dotenv import dotenv_values

from sqlalchemy import create_engine

db_url = "postgresql://username:password@localhost/database_name"
engine = create_engine(db_url)

OrderedDict([('db_user', 'driver'), ('db_password', 'driver'), ('db_host', 'localhost'), ('db_name', 'speed')])
print(dotenv_values)
for f in glob.glob("./*.json"):
    print(f)
    gu=geojson.loads(open(f).read())  # doctest: +ELLIPSIS
    for feat in gu.features:

    print(gu)
{"coordinates": [43.2..., -1.53...], "type": "Point"}