#!/bin/bash

composer install
php artisan key:generate
echo -n "$LARAVEL_STARTER_ADMIN_PASSWORD" | php artisan migrate:fresh --seed
