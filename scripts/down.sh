#!/bin/bash

printf "Powering down containers ...\n"
  docker-compose down
printf "...\e[92m done \e[39m\n\n"
