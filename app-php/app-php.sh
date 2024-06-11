#!/bin/bash

########################### SUPPRESSIONS ################################
# test de l'existence des conteneurs si c'est vrai je supprime les conteneurs
# -q: affiche uniquement les identifiants
[[ ! -z $(docker ps -aq --filter "name=app-php-*") ]] && docker rm -f $(docker ps -aq -f "name=app-php-*")

docker run \
       --name app-php-nginx \
       -d --restart unless-stopped \
       -p 8081:80 \
       nginx:1.27-bookworm


