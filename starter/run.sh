#!/bin/bash

export TERM=xterm-256color

CWD=$(pwd)

cd /app

sed -i .env.example -e "s/\$LARAVEL_STARTER_DB_NAME/$LARAVEL_STARTER_DB_NAME/"
sed -i .env.example -e "s/\$LARAVEL_STARTER_DB_USER/$LARAVEL_STARTER_DB_USER/"
sed -i .env.example -e "s/\$LARAVEL_STARTER_DB_PASS/$LARAVEL_STARTER_DB_PASS/"
sed -i .env.example -e "s/\$LARAVEL_STARTER_DB_HOST/$LARAVEL_STARTER_DB_HOST/"
sed -i .env.example -e "s/\$LARAVEL_STARTER_DB_PORT/$LARAVEL_STARTER_DB_PORT/"

rm -f .env
cp .env.example .env

[ -x ./docker-setup.sh ] && ./docker-setup.sh

[ -e ./docker-setup.sh ] && mv docker-setup.sh backup.docker-setup.sh

find storage/ bootstrap/ -type f -exec chmod 666 {} \;
find storage/ bootstrap/ -type d -exec chmod 777 {} \;

cd $CWD

exec supervisord -n

exit 0
