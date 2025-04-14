FROM ubuntu:24.04
LABEL com.antonraharja.image.authors="araharja@protonmail.com"

ARG LARAVEL_STARTER_ADMIN_PASSWORD
ARG LARAVEL_STARTER_VERSION
ARG LARAVEL_STARTER_DB_NAME
ARG LARAVEL_STARTER_DB_USER
ARG LARAVEL_STARTER_DB_PASS
ARG LARAVEL_STARTER_DB_HOST
ARG LARAVEL_STARTER_DB_PORT
ARG PHP_FPM_PORT

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies, prepare directories, and set up users in a single layer
RUN apt-get -y update && apt-get -y upgrade && \
    apt-get -yq install --no-install-recommends \
    ca-certificates supervisor git unzip curl mariadb-client mc composer \
    php8.3-fpm php8.3-cli php8.3-mysql php8.3-gd php8.3-curl php8.3-imap \
    php8.3-zip php8.3-xml php8.3-mbstring && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    sed -i /etc/php/8.3/fpm/pool.d/www.conf -e "s/listen = \/run\/php\/php8.3-fpm.sock/listen = $PHP_FPM_PORT/"

# get Laravel Starter
RUN rm -rf /app && mkdir -p /app && \
    git clone --branch $LARAVEL_STARTER_VERSION --depth=1 https://github.com/antonraharja/laravel-starter.git /app

RUN mkdir -p /var/www/html && rm -rf /var/www/html && ln -s /app/public /var/www/html

# Copy configuration files
COPY /starter/docker-setup.sh /app/docker-setup.sh
COPY /starter/.env.example /app/.env.example
COPY /starter/runner_php-fpm.sh /runner_php-fpm.sh
COPY /starter/supervisord-php-fpm.conf /etc/supervisor/conf.d/supervisord-php-fpm.conf
COPY /starter/run.sh /run.sh

# Set permissions
RUN chmod +x /app/docker-setup.sh /runner_php-fpm.sh /run.sh

# Set entrypoint
CMD ["/run.sh"]
