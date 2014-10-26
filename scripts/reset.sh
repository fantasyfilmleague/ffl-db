#!/bin/bash

sudo -u $POSTGRES_USERNAME psql -f "`dirname $0`/../sql/delete.sql"
sudo -u $POSTGRES_USERNAME psql -f "`dirname $0`/../sql/create.sql"
sudo -u $POSTGRES_USERNAME psql -f "`dirname $0`/../sql/schema.sql" -d $POSTGRES_DATABASE
