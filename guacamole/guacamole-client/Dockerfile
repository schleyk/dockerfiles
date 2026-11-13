FROM schleyk/guacamole:stable-build

# Hide Tomcat version
RUN mkdir -p /usr/local/tomcat/lib/org/apache/catalina/util \
&& echo "server.info=xxx" > /usr/local/tomcat/lib/org/apache/catalina/util/ServerInfo.properties
