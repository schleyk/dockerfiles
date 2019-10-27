## Features
- Based on tomcat:9.0.27-jdk8-adoptopenjdk-openj9 image.
- hide Tomcat version string.
- Used https://github.com/apache/guacamole-client GitHub source.
- Build Guacamole version 1.0.0-stable / 1.1.0-staging 
- Support LDAP(s)
- Support custom Root-CAs for LDAP(s) with custom endrepoint (Source https://github.com/schleyk/dockerfiles/tree/master/guacamole)
- Include plugins:
guacamole-auth-cas / guacamole-auth-duo / guacamole-auth-header / guacamole-auth-ldap / guacamole-auth-openidconnect / guacamole-auth-quickconnect / guacamole-auth-totp / guacamole-auth-radius


### docker-compose.yml example!
```
version: '2.1'

services:
  guacd:
    restart: always
    image: guacamole/guacd
    depends_on:
    - db
  guacamole:
    restart: always
    image: schleyk/guacamole:1.1.0-ff8fb55-tc9.0.27-jdk8-adoptopenjdk-openj9-hide
    links:
    - guacd
    - db
    volumes:
    - /srv/guacamole-dev/home:/home
    - /srv/guacamole-dev/custom-start.sh:/opt/guacamole/bin/custom-start.sh #do not forget to make executable at Host System!!!
    - /srv/guacamole-dev/server.xml:/usr/local/tomcat/conf/server.xml #for ProxyPass 
    environment:
    - MYSQL_HOSTNAME=db
    - MYSQL_DATABASE=guacamole
    - MYSQL_USER=guacamole
    - MYSQL_PASSWORD=changeme!
    - GUACD_HOSTNAME=guacd
    - GUACAMOLE_HOME=/home
	extra_hosts:
    - "srv-dc01.contoso.local:10.0.0.1" #for LDAPs and correct FQDN over WAN
    ports:
    - 8080:8080
    depends_on:
    - db
  db:
    image: mariadb:10
    restart: always
    volumes:
    - /srv/guacamole/db:/var/lib/mysql
    environment:
    - MYSQL_ROOT_PASSWORD=changeme!
    - MYSQL_DATABASE=guacamole
    - MYSQL_USER=guacamole
    - MYSQL_PASSWORD=changeme!
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    environment:
    - PMA_HOST:db
    ports:
    - "8282:80"
    depends_on:
    - db
```


### Nice to know:
- The orginal guacamole image use the old Tomcat/8.0.20 with security vulnerabilities. 
https://www.cvedetails.com/vulnerability-list/vendor_id-45/product_id-887/version_id-190754/Apache-Tomcat-8.0.20.html

- default login 
```guacadmin:guacadmin```

- Create initdb.sql: 
```docker run --rm schleyk/guacamole:1.1.0-ff8fb55-tc9.0.27-jdk8-adoptopenjdk-openj9-hide /opt/guacamole/bin/initdb.sh --mysql > initdb.sql```

- Upgrade SQL-Schema:
https://github.com/apache/guacamole-client/tree/master/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/schema/upgrade

- guacamole.properties for LDAP
LDAPS - settings:
``````
ldap-hostname: srv-dc01.contoso.local
ldap-port: 636
ldap-encryption-method: ssl
``````
LDAP - settings:
``````
ldap-hostname: srv-dc01.contoso.local
ldap-port: 389
ldap-encryption-method: none
``````
Connect with LDAP User:
``````
ldap-search-bind-dn: CN=svc-ldap,OU=example,DC=contoso,DC=local
ldap-search-bind-password: changeme!
``````
Configure base-dn and username-attribute:
``````
ldap-user-base-dn: OU=example,DC=contoso,DC=local
ldap-username-attribute: sAMAccountName
``````
Configure LDAP group membership match:
``````
ldap-user-search-filter: (&(|(objectclass=person))(|(|(memberof=CN=GRP-Guacamole,OU=example,DC=contoso,DC=local)(primaryGroupID=10282))))
``````

