#!/bin/sh -e
echo Custom script start.
# for OpenJDK
#keytool -importcert -noprompt -alias custom-ca -keystore /docker-java-home/jre/lib/security/cacerts -storepass changeit -file /home/custom-ca.cer
#keytool -keystore "/docker-java-home/jre/lib/security/cacerts" -storepass changeit -list | grep custom-ca

# for AdoptOpenJDK
cd $JAVA_HOME/jre/lib/security
keytool -importcert -noprompt -alias custom-ca -keystore cacerts -storepass changeit -file /home/custom-ca.cer -trustcacerts
keytool -keystore cacerts -storepass changeit -list | grep custom-ca
cd /opt/guacamole

exec ./bin/start.sh
