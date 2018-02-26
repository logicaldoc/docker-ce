#!/bin/bash
# wait-for-postgres.sh

set -e

host="$1"
dbname="$2"
user="$3"

export PGPASSWORD="$4"

shift 4
cmd="$@"

until psql -h "$host" -U "$user" -d "$dbname" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd
