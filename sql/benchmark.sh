#!/bin/bash

source ../helpers.sh

echo -n "SQL - SQLite - "
sqlite3 --version | head -n 1
DB_TYPE=sqlite benchmark ./play.sh

echo ""

echo -n "SQL - PostgreSQL - "
psql --version | head -n 1
DB_TYPE=postgres benchmark ./play.sh
