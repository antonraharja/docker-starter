FROM alpine:latest
LABEL com.antonraharja.image.authors="araharja@protonmail.com"

ARG LARAVEL_STARTER_ADMIN_PASSWORD
ARG LARAVEL_STARTER_VERSION
ARG LARAVEL_STARTER_DB_NAME
ARG LARAVEL_STARTER_DB_USER
ARG LARAVEL_STARTER_DB_PASS
ARG LARAVEL_STARTER_DB_HOST
ARG LARAVEL_STARTER_DB_PORT
ARG PHP_FPM_PORT

# Install dependencies, prepare directories, and set up users in a single layer
RUN apk update && apk upgrade && \
    apk add --no-cache \
    ca-certificates supervisor git unzip curl mariadb-client mc composer \
    php83-fpm php83-cli php83-mysqli php83-mysqlnd php83-pdo php83-pdo_mysql php83-pdo_sqlite \
    php83-gd php83-curl php83-imap php83-zip php83-xml php83-xmlreader php83-xmlwriter php83-json php83-tokenizer \
    php83-session php83-gettext php83-mbstring php83-pcntl php83-fileinfo php83-dom php83-intl php83-pecl-redis && \
    rm -rf /tmp/* /var/cache/apk/* && \
    sed -i /etc/php83/php-fpm.d/www.conf -e "s/listen = 127.0.0.1:9000/listen = 0.0.0.0:$PHP_FPM_PORT/"

# get Laravel Starter
RUN rm -rf /app && mkdir -p /app && \
    git clone --branch $LARAVEL_STARTER_VERSION --depth=1 https://github.com/antonraharja/laravel-starter.git /app && \
    mkdir -p /var/www/html && rm -rf /var/www/html && ln -s /app/public /var/www/html

# Copy configuration files
COPY /starter/docker-setup.sh /app/docker-setup.sh
COPY /starter/.env.example /app/.env.example
COPY /starter/supervisor.conf /etc/supervisor.conf
COPY /starter/run.sh /run.sh

# Set permissions
RUN chmod +x /app/docker-setup.sh /run.sh

# Set entrypoint
CMD ["/run.sh"]
