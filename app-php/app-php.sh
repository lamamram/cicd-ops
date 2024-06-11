#!/bin/bash

########################### SUPPRESSIONS ################################
# test de l'existence des conteneurs si c'est vrai je supprime les conteneurs
# -q: affiche uniquement les identifiants
[[ ! -z $(docker ps -aq --filter "name=app-php-*") ]] && docker rm -f $(docker ps -aq -f "name=app-php-*")

# $? code de retour de la commande dernière (0 OK , !=0 KO)
docker network ls | grep app-php
if [ $? -eq 0 ]; then
    docker network rm app-php
fi

############################## NETWORK #########################################

docker network create \
       --driver bridge \
       --subnet 172.18.0.0/24 \
       --gateway 172.18.0.1 \
       app-php

############################# CONTAINERS #######################################

docker run \
       --name app-php-mariadb \
       -d --restart unless-stopped \
       --network app-php \
       --env-file /vagrant/app-php/.env \
       -v /vagrant/app-php/mariadb-init.sql:/docker-entrypoint-initdb.d/mariadb-init.sql:ro \
       -v db_data:/var/lib/mysql \
       mariadb:11.1.5-jammy

# -e MARIADB_USER=test \
# -e MARIADB_PASSWORD=roottoor \
# -e MARIADB_DATABASE=test \
# -e MARIADB_ROOT_PASSWORD=roottoor \

docker run \
       --name app-php-fpm \
       -d --restart unless-stopped \
       --network app-php \
       -v /vagrant/app-php/index.php:/srv/index.php \
       bitnami/php-fpm:8.3-debian-12

# docker cp /vagrant/app-php/index.php app-php-fpm:/srv/index.php

docker run \
       --name app-php-nginx \
       -d --restart unless-stopped \
       -p 8081:80 \
       --network app-php \
       -v /vagrant/app-php/php8.3.conf:/etc/nginx/conf.d/php8.3.conf:ro \
       nginx:1.27-bookworm

# docker cp /vagrant/app-php/php8.3.conf \
#        app-php-nginx:/etc/nginx/conf.d/php8.3.conf

# changement de config  => redémarrer le service nginx
# normalement avec systemd => mais avec docker on pas besoin
# de systemd puisqu'on a --restart
# docker restart app-php-nginx
