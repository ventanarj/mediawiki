FROM php:8.1-apache

ENV MEDIAWIKI_VERSION=1.41.1 \
    MEDIAWIKI_HOME=/var/www/html \
    MEDIAWIKI_CONFIG_PATH=/config/LocalSettings.php

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        curl \
        libicu-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        unzip \
        git; \
    docker-php-ext-configure gd --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" \
        intl \
        gd \
        mbstring \
        zip \
        mysqli; \
    rm -rf /var/lib/apt/lists/*; \
    curl -fsSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_VERSION%.*}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o /tmp/mediawiki.tar.gz; \
    tar -xzf /tmp/mediawiki.tar.gz -C /tmp; \
    rm /tmp/mediawiki.tar.gz; \
    rm -rf "$MEDIAWIKI_HOME"/*; \
    mv "/tmp/mediawiki-${MEDIAWIKI_VERSION}"/* "$MEDIAWIKI_HOME"; \
    chown -R www-data:www-data "$MEDIAWIKI_HOME"

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
