FROM tomcat:7.0-jre8

MAINTAINER Dirk Stenger <stenger@lat-lon.de>
MAINTAINER Torsten Friebe <friebe@lat-lon.de>

# add TEAM engine webapp
ADD teamengine-web-*.war /root/
RUN cd /root/ && unzip -q teamengine-web-*.war -d /usr/local/tomcat/webapps/teamengine

# add common libs
ADD teamengine-web-*-common-libs.zip /root/
RUN cd /root/ && unzip -q teamengine-web-*-common-libs.zip -d /usr/local/tomcat/lib

# add TEAM engine console
ADD teamengine-console-*-base.zip /root/
RUN cd /root/ && unzip -q teamengine-console-*-base.zip -d /root/te_base

# set TE_BASE
ENV JAVA_OPTS="-Xms1024m -Xmx2048m -DTE_BASE=/root/te_base"

ADD ets-*-ctl.zip /root/
RUN cd /root/ && for file in ets-*-ctl.zip; do unzip -q $file -d /root/te_base/scripts; done

ADD ets-*-deps.zip /root/
RUN cd /root/ && for file in ets-*-deps.zip; do unzip -q -o $file -d /usr/local/tomcat/webapps/teamengine/WEB-INF/lib; done

RUN apt-get update && apt-get upgrade -y \
 && apt-get install -y \
    libtiff-tools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY find-repeated-jars.sh /usr/local/tomcat/webapps/teamengine/WEB-INF/lib/find-repeated-jars.sh
#COPY site /root/te_base/resources/site/

RUN rm -rf /root/te_base/scripts/note/ \
 && chmod +x /usr/local/tomcat/webapps/teamengine/WEB-INF/lib/find-repeated-jars.sh \
 && cd /usr/local/tomcat/webapps/teamengine/WEB-INF/lib/ \
 && /usr/local/tomcat/webapps/teamengine/WEB-INF/lib/find-repeated-jars.sh --remove \
 && mv /usr/local/tomcat/webapps/teamengine/ /usr/local/tomcat/webapps/te2

# run tomcat
CMD ["catalina.sh", "run"]
