#!/bin/bash

sudo -u postgres psql -f "`dirname $0`/../sql/delete.sql"
sudo -u postgres psql -f "`dirname $0`/../sql/create.sql"
sudo -u postgres psql -f "`dirname $0`/../sql/schema.sql" -d fantasy_film_league
