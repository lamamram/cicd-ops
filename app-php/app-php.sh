#!/bin/bash

########################### SUPPRESSIONS ################################
# test de l'existence des conteneurs si c'est vrai je supprime les conteneurs
# -q: affiche uniquement les identifiants
[[ ! -z $(docker ps -aq --filter "name=app-php-*") ]] && docker rm -f $(docker ps -aq -f "name=app-php-*")

docker run \
       --name app-php-fpm \
       -d --restart unless-stopped \
       bitnami/php-fpm:8.3-debian-12

docker cp /vagrant/app-php/index.php app-php-fpm:/srv/index.php

docker run \
       --name app-php-nginx \
       -d --restart unless-stopped \
       -p 8081:80 \
       nginx:1.27-bookworm

docker cp /vagrant/app-php/php8.3.conf \
       app-php-nginx:/etc/nginx/conf.d/php8.3.conf

# changement de config  => redémarrer le service nginx
# normalement avec systemd => mais avec docker on pas besoin
# de systemd puisqu'on a --restart
docker restart app-php-nginx
