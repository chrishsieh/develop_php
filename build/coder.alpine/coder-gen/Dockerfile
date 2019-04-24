ARG NODE_VERSION=10
FROM node:${NODE_VERSION}-alpine as builder-alpine
ARG CODER_VERSION
ENV CODER_VERSION $CODER_VERSION

RUN set -x \
    && apk --update add --no-cache --virtual .build-deps ca-certificates git libxkbfile-dev libsecret-dev gcc python make g++ curl \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && set +x \
    && coderlatest=$(curl -s https://api.github.com/repos/codercom/code-server/tags | grep 'tarball_url') \
    && coderlatest=$(echo $coderlatest | grep "${CODER_VERSION}" | cut -d '"' -f 4) \
    && curl -LOs $coderlatest \
    && coderfile=$(echo $coderlatest| cut -d '/' -f 8) \
    && tar zxf $coderfile \
    && rm -rf $coderfile \
    && coderfolder=$(ls | grep "codercom-code-server") \
    && mv $coderfolder coder \
    && set -x \
    && cd /usr/src/coder \
    && yarn && NODE_ENV=production yarn task build:server:binary \
    && cp /usr/src/coder/packages/server/cli-linux-x64 /usr/local/bin/code-server \
    && cd /usr/src \
    && rm -rf /usr/src/coder \
    && yarn cache clean \
    && apk del .build-deps \
    && rm -rf /root/.nbin /root/.node-gyp /var/cache/apk/* /tmp/*

FROM scratch

COPY --from=builder-alpine /usr/local/bin/code-server /code-server