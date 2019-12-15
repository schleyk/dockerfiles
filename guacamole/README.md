## Features
- Based on tomcat:9.0.30-jdk8-adoptopenjdk-openj9 image.
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
    image: schleyk/guacamole:1.0.0
    links:
    - guacd
    - db
    volumes:
    - /srv/guacamole/home:/home
    - /srv/guacamole/custom-start.sh:/opt/guacamole/bin/custom-start.sh #do not forget to make executable at Host System!!!
    - /srv/guacamole/server.xml:/usr/local/tomcat/conf/server.xml #for ProxyPass 
    environment:
    - MYSQL_HOSTNAME=db
    - MYSQL_DATABASE=guacamole
    - MYSQL_USER=guacamole
    - MYSQL_PASSWORD=changeme!
    - GUACD_HOSTNAME=guacd
    - GUACAMOLE_HOME=/home
	entrypoint: /opt/guacamole/bin/custom-start.sh
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
```docker run --rm schleyk/guacamole:1.0.0 /opt/guacamole/bin/initdb.sh --mysql > initdb.sql```

- Guacamole SSO for VNC, RDP, and SSH: https://guacamole.apache.org/releases/0.9.4/
Username/password parameter tokens
If you or your users use the same username/password for Guacamole as in their remote desktop accounts, you can now specify the 
“${GUAC_USERNAME}” or “${GUAC_PASSWORD}” tokens in any connection parameter. 

- All .jar  plugins are stored in the folder "/opt/guacamole" inside the Docker Image,
to activate plugins put the .jar into the "/home/extension" folder.

- Write your settings to "/home/guacamole.properties".

- Custom the login page https://github.com/Zer0CoolX/guacamole-customize-loginscreen-extension

- Add Proxy IP at line "trustedProxies" inside "server.xml" file!

- Upgrade SQL-Schema:
https://github.com/apache/guacamole-client/tree/master/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/schema/upgrade

- NGINX reverse Proxy:
``````
location / {
        proxy_pass http://guacamole:8080/guacamole/;
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_redirect off;
        proxy_read_timeout 120;
        proxy_connect_timeout 10;
}
``````
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