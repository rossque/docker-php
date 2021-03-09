# Docker Build

[![PHP-fpm](https://img.shields.io/badge/php-7.x--fpm-green)](https://hub.docker.com/_/php?tab=tags&page=1&name=7.1-fpm)
[![NGINX](https://img.shields.io/badge/nginx-1.19.2-green)](https://hub.docker.com/_/nginx?tab=tags)
[![MariaDB](https://img.shields.io/badge/mariadb-10.5.5-green)](https://hub.docker.com/_/mariadb?tab=tags)
[![Node](https://img.shields.io/badge/node-14.7.0-green)](https://hub.docker.com/_/node?tab=tags)
[![Composer](https://img.shields.io/badge/composer-1.10.10-green)](https://hub.docker.com/_/composer?tab=tags)
[![Redis](https://img.shields.io/badge/redis-6.0.6-green)](https://hub.docker.com/_/redis?tab=tags)

You will need to install [Docker](https://www.docker.com/) before using this script.
All [Docker](https://www.docker.com/) images will be installed from [DockerHub](https://hub.docker.com/).

## macOS
**Warning:** Some of these scripts within (**/node_modules/docker-bash-scripts/scripts/provision/***), are used for **macOS** **only!**
This docker environment has been created to work with Docker running on macOS. Scripts include, creating a valid SSL certificate to develop locally.

## Install
Use the following bash scripts to power up/down your docker builds.
```
npm install
```

### Power up container
Run the following to power up your container.
```
npm run up
```

### Power down container
Run the following to power down your container.
```
npm run down
```

### Install Laravel
Run the following to install Laravel.
```
npm run laravel
```

### Install Bedrock (for Wordpress)
Run the following to install Bedrock for Wordpress.
```
npm run bedrock
```

### Files/Sites
Two domains will be created for you. Both have a public root of /public.
```
/src/localhost.test
/src/api.localhost.test
```

### Setup guides
Please follow these guides if you need some additional help.

1. [How to use Docker](readme/README_Docker.md) 
2. [How to configure NGINX](readme/README_Nginx.md)
3. [How to connect to MySQL](readme/README_Mysql.md) 
3. [How to connect to Redis](readme/README_Redis.md) 
