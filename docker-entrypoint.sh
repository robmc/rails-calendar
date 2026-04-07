#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid

bundle exec rake db:create db:migrate

exec "$@"
