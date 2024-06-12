# pour les images de base (distribution linux)
# pour lancer des exécutables
# FROM scratch
FROM httpd:2.4

LABEL author="matt"
LABEL created_at="2024-06-12"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.item="httpd"

COPY httpd.conf /usr/local/apache2/conf/

RUN mkdir /usr/local/apache2/conf/sites

# COPY java_app.conf /usr/local/apache2/conf/sites/

EXPOSE 80
EXPOSE 443

# commande statique, non substituable, exécutée au moment du docker run (!= docker exec)
# Ecriture Tokenizée ["", "", ""] : protection pour les écritures trop complexes
ENTRYPOINT [ "httpd" ]
# commande dynamique, substituable, exécutée au moment du docker run
# CMD est ajoutée après l' ENTRYPOINT s'il existe
CMD [ "-D", "FOREGROUND" ]








