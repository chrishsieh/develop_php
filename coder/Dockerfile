FROM php:fpm

ARG CODER_VERSION

ENV CODER_VERSION $CODER_VERSION

RUN set -x \
    && cd /usr/src \
    && set +x \
    && coderlatest=$(curl -s https://api.github.com/repos/codercom/code-server/tags | grep 'tarball_url') \
    && coderlatest=$(echo $coderlatest | grep "${CODER_VERSION}" | cut -d '"' -f 4) \
    && curl -LOs $coderlatest \
    && coderfile=$(echo $coderlatest| cut -d '/' -f 8) \
    && tar zxf $coderfile \
    && rm -rf $coderfile \
    && coderfolder=$(ls | grep "codercom-code-server") \
    && mv $coderfolder coder
RUN set -x \
    && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests apt-utils ca-certificates \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash -\
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
        libxkbfile-dev libsecret-1-dev nodejs git \
    && npm install -g yarn@1.13 \
    && cd /usr/src/coder \
    && yarn && NODE_ENV=production yarn task build:server:binary \
    && cp /usr/src/coder/packages/server/cli-linux-x64 /usr/local/bin/code-server \
    && cd /usr/src \
    && rm -rf /usr/src/coder \
    && yarn cache clean \
    && npm uninstall -g yarn \
    && DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        libxkbfile-dev libsecret-1-dev nodejs git gcc python \
    && DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false apt-utils \
    && rm -rf /var/lib/apt/lists/* /root/.nbin /root/.npm /root/.node-gyp /usr/lib/python3.5 /tmp/*

FROM php:fpm

ENV BUILD_DEPS \
    cmake \
    libicu-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev libzip-dev

ENV RUN_DEPS \
    openssl net-tools sudo dumb-init bsdtar \
    gettext jq zip git unzip \
    locales locales-all wget curl \
    libfreetype6 libjpeg62-turbo libpng16-16 \
    libzip4 \
    ruby-full \
    nodejs \
    mysql-client \
    ca-certificates

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
# ---- Removing Build dependencies ----
    && DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${BUILD_DEPS} \
# ---- Installing Running dependencies ----
    && curl -sL https://deb.nodesource.com/setup_10.x | bash -\
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests ${RUN_DEPS} \
    && DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false apt-utils \
    && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates

# ---- Installing Running env ----
RUN set -x \
    && npm i npm@latest -g \
    && npm install -g grunt-cli webpack-cli \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer self-update \
    && gem install sass -v 3.4.25 \
# ---- Add user ----
    && adduser --gecos '' --disabled-password coder \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV VSCODE_EXTENSIONS "/home/coder/.local/share/code-server/extensions"
ENV VSCODE_DATA "/home/coder/.local/share/code-server"
ENV VSCODE_LOG "/home/coder/.cache/code-server/logs"

RUN mkdir -p /run.d

COPY coder-entrypoint.sh /coder-entrypoint.sh

COPY coder-entrypoint.d/*.sh /coder-entrypoint.d/

RUN chmod +X /coder-entrypoint.sh

USER coder

COPY --from=0 /usr/local/bin/code-server /usr/local/bin/code-server

RUN mkdir -p /home/coder/project \
    && chmod g+rw /home/coder/project \
    && mkdir -p ${VSCODE_EXTENSIONS} \
    && mkdir -p ${VSCODE_DATA} \
    && mkdir -p ${VSCODE_LOG}

### && composer global require hirak/prestissimo

WORKDIR /home/coder/project

VOLUME [ "/home/coder/project" ]

EXPOSE 8443


ENTRYPOINT ["/coder-entrypoint.sh"]