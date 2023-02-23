FROM centos:7.9.2009

LABEL author="matt"
LABEL created_at.year="2022"
LABEL created_at.month="2022-10"
LABEL stack="java_app"
LABEL stack.version="1.0.0"

# directive ARG: variable custom pilotée depuis la commande docker build
# via les options "--build-arg VAR=value"
ARG TOMCAT_VERSION_MAJOR
ARG TOMCAT_VERSION_MINOR

# exprérimentation: 1 run par cmd
# production: 1 run pour toutes les cmds (minimiser les couches)
# pour centos 8:
# sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
# sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
RUN mkdir /opt/tomcat && \
    curl -O https://downloads.apache.org/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_MINOR}/bin/apache-tomcat-${TOMCAT_VERSION_MINOR}.tar.gz && \
    tar -zxf apache-tomcat-${TOMCAT_VERSION_MINOR}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION_MINOR}/* /opt/tomcat/ && \
    cd /etc/yum.repos.d/ && \
    yum update -y && yum install java -y -q && \
    yum clean all && \
    rm -rf apache-tomcat*

WORKDIR /opt/tomcat/webapps

RUN curl -O https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war

# pour accéder, restaurer, sauvegarder les apps
VOLUME /opt/tomcat/webapps

# pour communiquer avec apache
EXPOSE 8080

# test de l'image dès le lancement du conteneur
# le checl démarre après start-period s
# test la commande CMD jusqu'à timeout s
# si concluant, OK
# sinon on réessaye retries * après interval s
HEALTHCHECK --interval=3s --timeout=10s --start-period=3s --retries=3 CMD grep "Server startup" /opt/tomcat/logs/catalina.*.log
# la cmd est exécutée à la création d'un conteneur,
# passe le status à starting le temps d'exécuter tous les essais
# passe le status à healthy si réussi
# passe le status à unhealthy si échoué après tous les essais
# permet de filtrer les conteneurs sur l'état 
# docker ps --filter health=unhealthy

# catalina.sh exécute en premier plan (foreground) vs startup.sh (background)
ENTRYPOINT [ "/opt/tomcat/bin/catalina.sh" ]

# run lance en one shot vs start qui lance un daemon
CMD [ "run" ]

# REM: si le build échoue, on peut éliminer les images avortées avec
# docker image rm $(docker images -q -f dangling="true")


