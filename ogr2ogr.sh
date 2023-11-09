#!/bin/bash

set -o allexport
source .env
set +o allexport

for file in `ls ./*.json`; do
echo $file
PGPASSWORD=$db_password psql -U $db_user -h $db_host $db_name -c 'truncate roads;'
ogr2ogr -f "PostGreSQL" PG:"host=$db_host user=$db_user dbname=$db_name password=$db_password" "$file" -nln roads
PGPASSWORD=$db_password psql -U $db_user -h $db_host $db_name -c "delete from roads rd using here2 h where h.id=rd.id;"
PGPASSWORD=$db_password psql -U $db_user -h $db_host $db_name -c "insert into here2 (ogc_fid, id, roads, divider, category, numlanes, endnodeid, featuretype, leftadminid, startnodeid, lanecategory, leftpostalid, offroadflags, rightadminid, speedlimitto, rightpostalid, speedcategory, isocountrycode, speedlimitfrom, functionalclass, traveldirection, \"@ns:com:here:xyz\", roadcharacteristics, \"@ns:com:here:mom:meta\", \"@ns:com:here:mom:rmob\", accesscharacteristics, \"@ns:com:here:mom:mapcreator\", intersectioncategory, zlevel, \"@ns:com:here:mom:delta\", \"@ns:com:here:mus\", wkb_geometry) SELECT ogc_fid, id, roads, divider, category, numlanes, endnodeid, featuretype, leftadminid, startnodeid, lanecategory, leftpostalid, offroadflags, rightadminid, speedlimitto, rightpostalid, speedcategory, isocountrycode, speedlimitfrom, functionalclass, traveldirection, \"@ns:com:here:xyz\", roadcharacteristics, \"@ns:com:here:mom:meta\", \"@ns:com:here:mom:rmob\", accesscharacteristics, \"@ns:com:here:mom:mapcreator\", intersectioncategory, zlevel, \"@ns:com:here:mom:delta\", \"@ns:com:here:mus\", wkb_geometry from roads"
#PGPASSWORD=$db_password psql -U $db_user -h $db_host $db_name -c 'insert into here2 (ogc_fid, id, roads, divider, category, numlanes, endnodeid, featuretype, leftadminid, startnodeid, lanecategory, leftpostalid, offroadflags, rightadminid, speedlimitto, rightpostalid, speedcategory, isocountrycode, speedlimitfrom, functionalclass, traveldirection, "@ns:com:here:xyz", roadcharacteristics, "@ns:com:here:mom:meta", "@ns:com:here:mom:rmob", accesscharacteristics, "@ns:com:here:mom:mapcreator", intersectioncategory, zlevel, "@ns:com:here:mom:delta", "@ns:com:here:mus", wkb_geometry) SELECT ogc_fid, id, roads, divider, category, numlanes, endnodeid, featuretype, leftadminid, startnodeid, lanecategory, leftpostalid, offroadflags, rightadminid, speedlimitto, rightpostalid, speedcategory, isocountrycode, speedlimitfrom, functionalclass, traveldirection, "@ns:com:here:xyz", roadcharacteristics, "@ns:com:here:mom:meta", "@ns:com:here:mom:rmob", accesscharacteristics, "@ns:com:here:mom:mapcreator", intersectioncategory, zlevel, "@ns:com:here:mom:delta", "@ns:com:here:mus", wkb_geometry from roads  where st_intersects((select st_collect(wkb_geometry) from here2), wkb_geometry)='t';'

done