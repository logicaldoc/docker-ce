#!/bin/bash
# wait-for-postgres.sh

set -e

host="$1"
export PGPASSWORD="changeme"

shift
cmd="$@"

until psql -h "$host" -U "ldoc" -d "logicaldoc" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd
