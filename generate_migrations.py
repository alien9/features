import geojson
import os
import glob, json
from dotenv import dotenv_values
conf=dotenv_values()
from sqlalchemy import create_engine
from sqlalchemy.sql import text

db_url = f"postgresql://{conf['db_user']}:{conf['db_password']}@{conf['db_host']}/{conf['db_name']}"
engine = create_engine(db_url)
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
session = Session(engine)

# Reflect the database schema
Base = automap_base()
Base.prepare(engine, reflect=True)
Here = Base.classes.here  # Replace "user" with the name of your table
done=list(open("done_here.csv").read().splitlines())
for f in glob.glob("./*.json"):
    print(f)
    if not f in done:
        gu=geojson.loads(open(f).read())  # doctest: +ELLIPSIS
        total=len(gu.features)
        n=0
        m=0
        for feat in gu.features:
            line=session.query(Here).filter_by(id=feat.id).first()
            if not line:
                line=Here(id=feat.id)
                m+=1
                for k in feat.properties.keys():
                    if type(feat.properties[k]) is list:
                        setattr(line, k.lower(), list(map(lambda u: json.dumps(u), feat.properties.get(k))))
                    elif type(feat.properties[k]) is dict:
                        setattr(line, k.lower(),  str(json.dumps(feat.properties.get(k))))
                    elif type(feat.properties[k]) is int:
                        setattr(line, k.lower(),  int(feat.properties.get(k)))
                    else:
                        setattr(line, k.lower(),  feat.properties.get(k))
                session.add(line)
                session.commit()
            if not line.wkb_geometry:   
                statement=text("update here set wkb_geometry=st_geomfromgeojson(:geometry) where id=:id")
                session.execute(statement, {"geometry":json.dumps(feat.geometry), "id":feat.id})
                session.commit()
            n+=1
            print(f"\r{n} de {total}", end="")
        print(f"\n{m} insertions")
        with open("done_here.csv", "a+") as fu:
            fu.write(f"{f}\n")
    else:
        print(f"{f} was already loaded")





