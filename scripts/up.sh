#!/bin/bash

set -e

FRAMEWORK=$1
if [ -z "$FRAMEWORK" ]
then
    FRAMEWORK="php"
fi

# Global variables
CWD=$PWD
SSL_DAYS=365
SSL_DAYS_LEFT=0
CURRENT_DATE=$(date +%s)
PHP_REPOSITORY=$(basename "$PWD")_php:latest
CONTAINERS="composer node php php_api nginx mysql redis"
SCRIPTS="./node_modules/docker-bash-scripts/scripts"

if [[ ! -d $SCRIPTS ]]
then
  printf "Missing NPM package: "
  printf "$SCRIPTS"
  printf "To continue, run:\nnpm install\n\n"
  exit 1
fi

# PHP version
if [[ ! -f $CWD/.env ]]
then

  # printf "\nDeleting build $PHP_REPOSITORY \n"
  # docker rmi $PHP_REPOSITORY --force
  # printf "...\e[92m done \e[39m\n"

  printf "\nWhat version of PHP would you like to install?\n"
  PHP=`sh $SCRIPTS/provision/php-versions.sh $CWD $PHP_REPOSITORY`

  printf "\nWhat version of NODE would you like to install?\n"
  NODE=`sh $SCRIPTS/provision/node-versions.sh $CWD`
  
fi

# Configure hosts files
sh $SCRIPTS/provision/hosts.sh localhost.test
sh $SCRIPTS/provision/hosts.sh api.localhost.test

# Create .env file
sh $SCRIPTS/provision/env.sh $CWD $PHP $NODE

# Get MYSQL_DATABASE variable
MYSQL_DATABASE=$(grep MYSQL_DATABASE $CWD/.env | cut -d '=' -f2)
export MYSQL_DATABASE=$MYSQL_DATABASE

# Create certs directory
sh $SCRIPTS/provision/create-certs-directory.sh

# Create ssh directory
sh $SCRIPTS/provision/create-ssh-directory.sh $CWD

# Create an SSL timestamp (seconds)
sh $SCRIPTS/provision/create-ssl-timestamp.sh $SSL_DAYS $CURRENT_DATE

# Check days until SSL certificate expires
SSL_EXPIRY_DATE=$(grep SSL_EXPIRY_DATE ~/.docker/certs/.SSL_timestamp | cut -d '=' -f2)
SSL_DAYS_DIFF=$(echo "($SSL_EXPIRY_DATE - $CURRENT_DATE) / 86400" | bc)

# Create Certificate Authority
sh $SCRIPTS/provision/create-certificate-authority.sh $SSL_DAYS_DIFF $SSL_DAYS_LEFT

# Create SSL certificates
sh $SCRIPTS/provision/create-certificate.sh localhost.test $SSL_DAYS $SSL_DAYS_LEFT $CURRENT_DATE
sh $SCRIPTS/provision/create-certificate.sh api.localhost.test $SSL_DAYS $SSL_DAYS_LEFT $CURRENT_DATE

# Build docker containers
sh $SCRIPTS/provision/build-containers.sh $CWD $CONTAINERS

# Database
sh $SCRIPTS/provision/database.sh $CWD $MYSQL_DATABASE localhost.test

# Configure php
sh $SCRIPTS/provision/php-ini.sh $CWD php
sh $SCRIPTS/provision/php-ini.sh $CWD php_api

# Restart containers
sh $SCRIPTS/provision/restart-containers.sh $CWD $CONTAINERS

# Install framework
sh $SCRIPTS/provision/frameworks/$FRAMEWORK.sh $CWD php localhost.test

# Install api
sh $SCRIPTS/provision/frameworks/php.sh $CWD php_api api.localhost.test

# Create ssh key
sh $SCRIPTS/provision/install-ssh-key.sh $CWD php
sh $SCRIPTS/provision/install-ssh-key.sh $CWD php_api

# Install horizon
if [ $FRAMEWORK == "laravel" ]
then
  sh $SCRIPTS/provision/install-supervisor-horizon.sh $CWD php localhost.test
  sh $SCRIPTS/provision/install-supervisor-horizon.sh $CWD php_api api.localhost.test
fi

# Start cronjob
sh $SCRIPTS/provision/install-crontab.sh $CWD php localhost.test
sh $SCRIPTS/provision/install-crontab.sh $CWD php_api api.localhost.test

# Restart containers
sh $SCRIPTS/provision/restart-containers.sh $CWD $CONTAINERS

# Configure hosts files
sh $SCRIPTS/provision/install-nginx-hosts.sh $CWD php api.localhost.test
sh $SCRIPTS/provision/install-nginx-hosts.sh $CWD php_api localhost.test

# Print login credentials
sh $SCRIPTS/provision/credentials.sh $MYSQL_DATABASE

# Connect to container
sh $SCRIPTS/provision/ssh-connect.sh $CWD php

exit 0