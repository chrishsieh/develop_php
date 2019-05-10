FROM php:7-fpm

ENV BUILD_DEPS="cmake libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev libmagickwand-dev" \
    RUN_DEPS="sudo dumb-init gettext jq zip git unzip locales wget curl \
            libfreetype6 libjpeg62-turbo libpng16-16 libzip4 libmagickwand-6.q16-3 \
            socat supervisor ca-certificates" \
    RUN_DEV_DEPS="openssl net-tools bsdtar ruby-full nodejs mysql-client"

RUN set -x \
# ---- Installing Build dependencies ----
    && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests apt-utils ca-certificates \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests ${BUILD_DEPS} \
# ---- Update PHP pecl ----
    && pecl channel-update pecl.php.net \
# ---- Installing PHP Extension: exif ----
    && /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) exif \
    && (rm -rf /usr/local/lib/php/test/exif || true) \
    && (rm -rf /usr/local/lib/php/doc/exif || true) \
# ---- Installing PHP Extension: gd ----
    && /usr/local/bin/docker-php-ext-configure gd --with-gd --with-png-dir=/usr --with-zlib-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr \
    && /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd \
    && (rm -rf /usr/local/lib/php/test/gd || true) \
    && (rm -rf /usr/local/lib/php/doc/gd || true) \
# ---- Installing PHP Extension: gettext ----
    && /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gettext \
    && (rm -rf /usr/local/lib/php/test/gettext || true) \
    && (rm -rf /usr/local/lib/php/doc/gettext || true) \
# ---- Installing PHP Extension: imagick ----
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && (rm -rf /usr/local/lib/php/test/imagick || true) \
    && (rm -rf /usr/local/lib/php/doc/imagick || true) \
# ---- Installing PHP Extension: intl ----
    && /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) intl \
    && (rm -rf /usr/local/lib/php/test/intl || true) \
    && (rm -rf /usr/local/lib/php/doc/intl || true) \
# ---- Installing PHP Extension: mysqli ----
    && /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mysqli \
    && (rm -rf /usr/local/lib/php/test/mysqli || true) \
    && (rm -rf /usr/local/lib/php/doc/mysqli || true) \
# ---- Installing PHP Extension: pdo_mysql ----
    && /usr/local/bin/docker-php-ext-configure pdo_mysql --with-zlib-dir=/usr \
    && /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_mysql \
    && (rm -rf /usr/local/lib/php/test/pdo_mysql || true) \
    && (rm -rf /usr/local/lib/php/doc/pdo_mysql || true) \
# ---- Installing PHP Extension: zip ----
    && /usr/local/bin/docker-php-ext-configure zip --with-zlib-dir=/usr --with-pcre-dir=/usr --with-libzip \
    && /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip \
    && (rm -rf /usr/local/lib/php/test/zip || true) \
    && (rm -rf /usr/local/lib/php/doc/zip || true) \
# ---- Installing PHP Extension: xdebug ----
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && (rm -rf /usr/local/lib/php/test/xdebug || true) \
    && (rm -rf /usr/local/lib/php/doc/xdebug || true) \
# ---- Removing Build dependencies ----
    && DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${BUILD_DEPS} \
# ---- Installing Running dependencies ----
    && curl -sL https://deb.nodesource.com/setup_8.x | bash -\
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests ${RUN_DEPS} ${RUN_DEV_DEPS} \
    && DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false apt-utils \
    && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates

COPY --from=chrishsieh/develop_php:coder-stretch-slim /code-server /usr/local/bin/code-server
COPY --from=chrishsieh/develop_php:coder-stretch-slim /etc/CODER_VER /etc/CODER_VER
COPY locale.md /etc/locale.md

# ---- Installing Running env ----
RUN set -x \
    && npm i npm@latest -g \
    && npm install -g grunt-cli webpack-cli \
    && npm cache clean --force \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer self-update \
    && composer clearcache \
    && gem install sass -v 3.4.25 \
    && rm -rf /etc/supervisor* \
    && mkdir -p /etc/supervisor/conf.d \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /run.d \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
# ---- Add user ----
    && adduser --gecos '' --disabled-password coder \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && cat /etc/locale.md | xargs -i sed -i 's/# {}.UTF-8 UTF-8/{}.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && cat /etc/locale.md | xargs -i localedef -i {} -f UTF-8 {} \
    && echo "alias ls='ls --color=auto'" >> /root/.bashrc \
    && echo "alias ll='ls --color=auto -l'" >> /root/.bashrc \
    && echo "alias l='ls --color=auto -lA'" >> /root/.bashrc

ENV VSCODE_EXTENSIONS="/home/coder/.local/share/code-server/extensions" \
    VSCODE_DATA="/home/coder/.local/share/code-server" \
    VSCODE_LOGS="/home/coder/.cache/code-server/logs" \
    VSCODE_WORK_DIR="/var/www" \
    HOME="/home/coder" \
    TERM="xterm-color"

COPY supervisord.conf /etc/supervisor/supervisord.conf

USER coder

RUN composer global require hirak/prestissimo \
    && composer clearcache \
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