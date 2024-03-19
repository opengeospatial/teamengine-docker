FROM tomcat:7.0-jre8

MAINTAINER Dirk Stenger <stenger@lat-lon.de>
MAINTAINER Torsten Friebe <friebe@lat-lon.de>

# add TEAM engine webapp
ADD maven/teamengine-web-*.war /root/
RUN cd /root/ && unzip -q teamengine-web-*.war -d /usr/local/tomcat/webapps/teamengine

# add common libs
ADD maven/teamengine-web-*-common-libs.zip /root/
RUN cd /root/ && unzip -q teamengine-web-*-common-libs.zip -d /usr/local/tomcat/lib

# add TEAM engine console
ADD maven/teamengine-console-*-base.zip /root/
RUN cd /root/ && unzip -q teamengine-console-*-base.zip -d /usr/local/tomcat/te_base

# set TE_BASE
ENV JAVA_OPTS="-Xms1024m -Xmx6144m -DTE_BASE=/usr/local/tomcat/te_base -Djavax.xml.parsers.DocumentBuilderFactory=com.sun.org.apache.xerces.internal.jaxp.DocumentBuilderFactoryImpl"

### security log4j CVE-2021-44228
ENV CATALINA_OPTS="$CATALINA_OPTS -Dlog4j2.formatMsgNoLookups=true"

ADD maven/ets-*-ctl.zip /root/
RUN cd /root/ && for file in ets-*-ctl.zip; do unzip -q $file -d /usr/local/tomcat/te_base/scripts; done

ADD maven/ets-*-deps.zip /root/
RUN cd /root/ && for file in ets-*-deps.zip; do unzip -q -o $file -d /usr/local/tomcat/webapps/teamengine/WEB-INF/lib; done

RUN sed -i s/security.debian.org/archive.debian.org/g /etc/apt/sources.list \
    && sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list \
    && sed -i "s/deb http:\/\/archive.debian.org\/debian stretch-updates main/#deb http:\/\/archive.debian.org\/debian stretch-updates main/g" /etc/apt/sources.list

RUN apt-get update && apt-get upgrade -y \
 && apt-get install -y \
    libtiff-tools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY delete-duplicate-dependencies.sh /usr/local/tomcat/webapps/teamengine/WEB-INF/lib/delete-duplicate-dependencies.sh
COPY list-of-duplicate-dependencies.txt /usr/local/tomcat/webapps/teamengine/WEB-INF/lib/list-of-duplicate-dependencies.txt

RUN rm -rf /usr/local/tomcat/te_base/scripts/note/ \
 && chmod +x /usr/local/tomcat/webapps/teamengine/WEB-INF/lib/delete-duplicate-dependencies.sh \
 && cd /usr/local/tomcat/webapps/teamengine/WEB-INF/lib/ \
 && /usr/local/tomcat/webapps/teamengine/WEB-INF/lib/delete-duplicate-dependencies.sh

RUN useradd tomcat && chown -R tomcat:tomcat /usr/local/tomcat

USER tomcat

# run tomcat
CMD ["catalina.sh", "run"]
