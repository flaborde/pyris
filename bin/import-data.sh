#!/bin/bash
IRIS_URL="https://www.data.gouv.fr/s/resources/contour-des-iris-insee-tout-en-un/20150428-161348/iris-2013-01-01.zip"
IRIS_ZIPFILE="${IRIS_URL##*/}"
IRIS_SHPFILE="${IRIS_ZIPFILE%.zip}.shp"

GOSU=""
[ -x "$(which gosu)" ] && GOSU=(gosu postgres)

set -e

wget -nv "$IRIS_URL"
unzip "$IRIS_ZIPFILE"
rm "$IRIS_ZIPFILE"

# You need to have a CREATEDB and SUPERUSER roles.
# If it's not the case
#   > ALTER ROLE <your_username> CREATEDB SUPERUSER;
# in a psql shell as a 'postgres' user.
"${GOSU[@]}" createdb pyris
"${GOSU[@]}" psql pyris -c "CREATE EXTENSION postgis;"
echo "The database 'pyris' has been created."

# You need to install PostGIS
# Suppose the database 'pyris' exists

echo "######################################################"
echo "Use 'shp2pgsql' to insert some data from the shp file"
echo "######################################################"
"${GOSU[@]}" shp2pgsql -D -W latin1 -I -s 4326 "$IRIS_SHPFILE" geoiris | "${GOSU[@]}" psql -d pyris

# don't know why but there are several duplications in the shapefile (same geometries for the same IRIS)
echo "######################################################"
echo "Data cleaning: remove some duplicated rows"
echo "######################################################"
"${GOSU[@]}" psql pyris -c "DELETE FROM geoiris WHERE gid IN (SELECT gid FROM (SELECT gid,RANK() OVER (PARTITION BY dcomiris ORDER BY gid) FROM geoiris) AS X WHERE X.rank > 1);
"

echo "######################################################"
echo "There are"
"${GOSU[@]}" psql pyris -c 'SELECT COUNT(1) FROM geoiris;'

