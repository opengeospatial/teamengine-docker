FROM tomcat:10.1.42-jre17

MAINTAINER Dirk Stenger <stenger@lat-lon.de>
MAINTAINER Torsten Friebe <friebe@lat-lon.de>

RUN apt update && apt install -y unzip

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
ENV JAVA_OPTS="-Xms1024m -Xmx6144m -DTE_BASE=/usr/local/tomcat/te_base"

### security log4j CVE-2021-44228
ENV CATALINA_OPTS="$CATALINA_OPTS -Dlog4j2.formatMsgNoLookups=true"

ADD maven/ets-*-ctl.zip /root/
RUN cd /root/ && for file in ets-*-ctl.zip; do unzip -q $file -d /usr/local/tomcat/te_base/scripts; done

ADD maven/ets-*-deps.zip /root/
RUN cd /root/ && for file in ets-*-deps.zip; do unzip -q -o $file -d /usr/local/tomcat/webapps/teamengine/WEB-INF/lib; done

RUN apt-get update && apt-get upgrade -y \
 && apt-get install -y \
    libtiff-tools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN rm -rf /usr/local/tomcat/te_base/scripts/note/

RUN useradd tomcat && chown -R tomcat:tomcat /usr/local/tomcat

USER tomcat

# run tomcat
CMD ["catalina.sh", "run"]
