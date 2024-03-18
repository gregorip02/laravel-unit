FROM unit:php8.2

WORKDIR /var/www/app/

# Install server dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends lsb-release gnupg zip unzip curl git openssl openssh-client supervisor \
        libpng-dev libonig-dev libxml2-dev libpq-dev

# Install server dependencies
RUN docker-php-ext-install pdo_pgsql intl pdo_mysql mbstring exif pcntl bcmath opcache \
    # add postgresql repository
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgres.gpg \
    && sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    # add nodejs repository
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    # install composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs mariadb-client \
        postgresql-client-12 postgresql-client-13 postgresql-client-14 \
        postgresql-client-15 postgresql-client-16 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY config.json /docker-entrypoint.d/config.json
