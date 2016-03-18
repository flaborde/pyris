#!/bin/bash

# You need to install PostGIS
# Suppose the database 'pyris' exists

# In your database, first do
# > create extension postgis;
# with the superuser role

user="user"

shp2pgsql -W latin1 -I -s 4326 iris-2013-01-01.shp geoiris | psql -d pyris -U $user

# It could be a quite long
