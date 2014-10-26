#!/bin/bash

sudo -u $POSTGRES_USERNAME psql -c "DROP DATABASE $POSTGRES_DATABASE;"
sudo -u $POSTGRES_USERNAME psql -c "CREATE DATABASE $POSTGRES_DATABASE OWNER postgres ENCODING 'UTF8' LC_COLLATE 'en_US.utf8' LC_CTYPE 'en_US.UTF8' template template0;"
sudo -u $POSTGRES_USERNAME psql -f "`dirname $0`/../sql/schema.sql" -d $POSTGRES_DATABASE
