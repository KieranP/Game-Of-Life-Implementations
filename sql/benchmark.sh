#!/bin/bash

source ../helpers.sh

compile go build -o play .

echo -n "SQL - SQLite - "
sqlite3 --version | head -n 1
DB_TYPE=sqlite benchmark ./play

echo ""

echo -n "SQL - PostgreSQL - "
psql --version | head -n 1
DB_TYPE=postgres benchmark ./play
