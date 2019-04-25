ARG NODE_VERSION=10
FROM node:${NODE_VERSION}-stretch-slim as builder-stretch-slim
ARG CODER_VERSION=1.939-vsc1.33.1
ENV CODER_VERSION $CODER_VERSION

RUN set -x \
    && cd /usr/src \
    && set +x \
    && coderlatest=$(curl -s https://api.github.com/repos/codercom/code-server/tags | grep 'tarball_url') \
    && coderlatest=$(echo $coderlatest | cut -d '"' -f 4) \
    && curl -LOs $coderlatest \
    && coderfile=$(echo $coderlatest| cut -d '/' -f 8) \
    && tar zxf $coderfile \
    && rm -rf $coderfile \
    && coderfolder=$(ls | grep "codercom-code-server") \
    && mv $coderfolder coder

RUN set -x \
    && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests apt-utils ca-certificates \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
        libxkbfile-dev libsecret-1-dev git gcc python g++ make \
    && npm install -g yarn@1.13 \
    && cd /usr/src/coder \
    && yarn && NODE_ENV=production yarn task build:server:binary \
    && cp /usr/src/coder/packages/server/cli-linux-x64 /usr/local/bin/code-server \
    && echo "${CODER_VERSION}" > /usr/local/bin/CODER_VER \
    && cd /usr/src \
    && rm -rf /usr/src/coder \
    && yarn cache clean \
    && npm uninstall -g yarn \
    && DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        libxkbfile-dev libsecret-1-dev git gcc python g++ make \
    && DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false apt-utils \
    && rm -rf /var/lib/apt/lists/* /root/.nbin /root/.npm /root/.node-gyp /usr/lib/python3.5 /tmp/*

FROM scratch

COPY --from=builder-stretch-slim /usr/local/bin/code-server /code-server
COPY --from=builder-stretch-slim /usr/local/bin/CODER_VER /etc/CODER_VER