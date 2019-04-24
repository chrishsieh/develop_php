FROM php:fpm-alpine

ENV BUILD_DEPS="cmake icu-dev freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev imagemagick-dev gettext-dev" \
    RUN_DEPS="openssl net-tools sudo dumb-init libarchive-tools icu gettext jq zip git wget \
            freetype libjpeg-turbo libpng libzip ruby-full npm composer python g++ mysql-client imagemagick \
            socat supervisor ca-certificates shadow bash"

RUN set -x \
# ---- Installing Build dependencies ----
    && apk --update add --no-cache --virtual .build-deps ${PHPIZE_DEPS} ${BUILD_DEPS} \
# ---- Installing PHP Extension: gd zip intl gettext mysqli pdo_mysql exif ----
    && docker-php-ext-configure gd --with-gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/ --enable-gd-jis-conv \
    && docker-php-ext-configure zip --with-libzip \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} \
        intl gettext mysqli pdo_mysql exif gd zip \
    && (rm -rf /usr/local/lib/php/test/gd || true) \
    && (rm -rf /usr/local/lib/php/doc/gd || true) \
# ---- Update PHP pecl ----
    && pecl channel-update pecl.php.net \
# ---- Installing PHP Extension: imagick ----
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && (rm -rf /usr/local/lib/php/test/imagick || true) \
    && (rm -rf /usr/local/lib/php/doc/imagick || true) \
# ---- Installing PHP Extension: xdebug ----
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && (rm -rf /usr/local/lib/php/test/xdebug || true) \
    && (rm -rf /usr/local/lib/php/doc/xdebug || true) \
# ---- Removing Build dependencies ----
    && apk del .build-deps \
# ---- Installing Running dependencies ----
    && apk --update add ${RUN_DEPS} \
    && update-ca-certificates

COPY --from=chrishsieh/develop_php:coder-alpine /code-server /usr/local/bin/code-server

# ---- Installing Running env ----
RUN set -x \
    && npm i npm@latest -g \
    && npm install -g grunt-cli webpack-cli \
    && composer self-update \
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

RUN composer global require hirak/prestissimo \
    && mkdir -p ${VSCODE_EXTENSIONS} \
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