## nous allons utiliser une image centos 9: quay.io/centos/centos:stream9
FROM quay.io/centos/centos:stream9
## documenter l'image
LABEL author="matt"
LABEL created_at="2024-06-12"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.item="tomcat"

ARG TOMCAT_VERSION_MAJOR=9
ARG TOMCAT_VERSION_FULL
## ajouter un dossier /opt/tomcat
## injecter le fichier https://downloads.apache.org/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.tar.gz dans ce dossier
## décomprésser dans ce dossier sans dossier intermédiaire 
## installer java (yum)
## ajouter un utilisateur tomcat avec le dossier /opt/tomcat comme home avec le groupe propriétaire
## changer le home de l'image vers /opt/tomcat/webapps

## optimisations
## 1/ travailler sur les flux de sorties / entrée vs gérer des fichiers stockés
## 2/ chainer les commandes pour minimiser les RUN et avoir des créations / suppressions dans la même couche
## 3/ utilisation des paquets / dépendances les plus légères
## 4/ en cas d'utilisation de gestionnaires de paquets il faut nettoyer le cache et les paquets & deps non utilisés
## SUITE 1/ utiliser un java jre installation source
## SUITE 2/ utliser une image FROM optimisée => alpine (image raspberry / arduino)

RUN mkdir /opt/tomcat && \
    curl https://downloads.apache.org/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz \
    | tar -xzv -C /opt/tomcat/ --strip-components=1 && \
    yum update -q && yum install java-1.8.0-openjdk-headless -yq && \
    yum clean all && rm -rf /var/cache/yum && \
    useradd -m -d /opt/tomcat -U tomcat


WORKDIR /opt/tomcat/webapps
## télécharger l'application sample https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war dans le dossier home 

ADD https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war .

## spécifier le propriétaire et groupe du dossoer /opt/tomcat et tout son contenu 
RUN chown -R tomcat:tomcat /opt/tomcat

## changer l'utilisateur à tomcat
USER tomcat
## persister le dossier home pour accéder ou sauvegarder les apps
VOLUME /opt/tomcat/webapps
## pour communiquer avec httpd avec le port 8080
EXPOSE 8080
## exécuter de manière statique (sans substitution) le binaire en foreground catalina.sh vs startup.sh ???
ENTRYPOINT [ "/opt/tomcat/bin/catalina.sh" ]
## ajouter la sous commande pour lancer en one shot run ou start ???
CMD [ "run" ]

# healthcheck one-shot avec un retry fini
# healthcheck périodique sans retry (inifini)
# après le lancement du CMD précédent (docker run),
# on attent 3s (start-period)
# pour lancer CMD du HEALTHCHECK avec un timeout de 5s,
# si le CMD est vrai (exit-code 0) => le docker ps donne un STATUS (healthy),
# sinon on peut réessayer 3x (retries), avec une durée d'attente de 3s(interval)
HEALTHCHECK \
    --start-period=3s \
    --timeout=5s \
    --retries=3 \
    --interval=3s \
    CMD grep "Server startup" /opt/tomcat/logs/catalina.*.log



