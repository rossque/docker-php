ARG NODE_IMAGE=node:14.8.0-slim
ARG PHP_IMAGE=rossque/php:7.4

FROM $NODE_IMAGE AS node
FROM $PHP_IMAGE AS php

COPY --from=php /usr/local/etc/php /usr/local/etc/.php_install
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/nodejs /usr/local/bin/nodejs
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /opt /opt
COPY --from=node /usr/local/bin/yarn /usr/local/bin/yarn
COPY --from=node /usr/local/bin/yarnpkg /usr/local/bin/yarnpkg

RUN ln -s /opt/yarn-*/bin/yarn /usr/local/bin/yarn --force
RUN ln -s /opt/yarn-*/bin/yarnpkg /usr/local/bin/yarnpkg --force

RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx


