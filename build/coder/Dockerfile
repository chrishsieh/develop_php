FROM php:fpm

ENV BUILD_DEPS="cmake libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev" \
    RUN_DEPS="openssl net-tools sudo dumb-init bsdtar gettext jq zip git unzip locales locales-all wget curl \
            libfreetype6 libjpeg62-turbo libpng16-16 libzip4 ruby-full nodejs mysql-client \
            socat supervisor ca-certificates"

RUN set -x \
# ---- Installing Build dependencies ----
    && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests apt-utils ca-certificates \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests ${BUILD_DEPS} \
# ---- Installing PHP Extension: gd ----
    && /usr/local/bin/docker-php-ext-configure gd --with-gd --with-png-dir=/usr --with-zlib-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr --enable-gd-jis-conv \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} \
        gettext mysqli pdo_mysql exif gd zip \
    && (rm -rf /usr/local/lib/php/test/gd || true) \
    && (rm -rf /usr/local/lib/php/doc/gd || true) \
# ---- Installing PHP Extension: xdebug ----
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && (rm -rf /usr/local/lib/php/test/xdebug || true) \
    && (rm -rf /usr/local/lib/php/doc/xdebug || true) \
# ---- Removing Build dependencies ----
    && DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${BUILD_DEPS} \
# ---- Installing Running dependencies ----
    && curl -sL https://deb.nodesource.com/setup_8.x | bash -\
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests ${RUN_DEPS} \
    && DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false apt-utils \
    && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates

COPY --from=chrishsieh/develop_php:coder /usr/local/bin/code-server /usr/local/bin/code-server

# ---- Installing Running env ----
RUN set -x \
    && npm i npm@latest -g \
    && npm install -g grunt-cli webpack-cli \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer self-update \
    && composer global require hirak/prestissimo \
    && gem install sass -v 3.4.25 \
    && rm -rf /etc/supervisor* \
    && mkdir -p /etc/supervisor/conf.d \
    && mkdir -p /var/log/supervisor \
# ---- Add user ----
    && adduser --gecos '' --disabled-password coder \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV VSCODE_EXTENSIONS="/home/coder/.local/share/code-server/extensions" \
    VSCODE_DATA="/home/coder/.local/share/code-server" \
    VSCODE_LOGS="/home/coder/.cache/code-server/logs" \
    VSCODE_WORK_DIR="/var/www" \
    HOME="/home/coder"

RUN mkdir -p /run.d
ADD supervisord.conf /etc/supervisor/supervisord.conf

USER coder

RUN mkdir -p ${VSCODE_EXTENSIONS} \
    && mkdir -p ${VSCODE_DATA} \
    && mkdir -p ${VSCODE_LOGS}

WORKDIR /var/www

VOLUME [ "/var/www" ]

EXPOSE 8443

USER root
COPY coder-entrypoint.sh /coder-entrypoint.sh
COPY coder-entrypoint.d/*.sh /coder-entrypoint.d/
RUN chmod +x /coder-entrypoint.sh && chmod +x /coder-entrypoint.d/*.sh

ENTRYPOINT ["dumb-init", "/coder-entrypoint.sh"]