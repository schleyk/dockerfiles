# BareOS Director
![](https://www.bareos.com/files/Logos/Bareos/Logo_gesamt.png)

**This image was made and maintained for Motius and we have no intention to make this official. Support won't be regular so if there's an update, or a fix, you can open a pull request. Any contribution is welcome, but please be aware I'm very busy currently. Before opening an issue, please check if there's already one related. Also please use Github instead of Docker Hub, otherwise I won't see your comments. Thanks.**

![](https://img.shields.io/docker/pulls/motius/bareos-dir.svg) ![](https://img.shields.io/github/commit-activity/y/motius/dockerfiles.svg) ![](https://img.shields.io/docker/automated/motius/bareos-dir.svg)
![](https://img.shields.io/docker/build/motius/bareos-dir.svg) ![](https://circleci.com/gh/motius/dockerfiles/tree/master.svg?style=shield)

Based on https://github.com/shoifele/bareos-dir
### Features
- Build every night to keep the container up to date
- Automatic generation of template config
- Creation or migration of the database (catalog)
- Mail handling

### Tags
- **latest** : latest stable version. (17.2)
- **17.2** : latest 17.2 version
- **16.2** : latest 16.2 version

### Environment variables
- **TIMEZONE** Configures the timezone e.g. *Europe/Berlin*
- **DB_HOST** Defines the database host e.g. *postgres*
- **DB_PORT** Defines the password for the database e.g. *5432*
- **DB_PASS** Defines the password for the database e.g. *bareos*
- **DB_NAME** Defines the password for the database e.g. *bareos*
- **DB_USER** Defines the password for the database e.g. *bareos*
- **SMTP_ACCOUNT** SMTP login account e.g. *test@example.com*
- **SMTP_FROM_ACCOUNT** The from in the mail e.g. *test@example.com*
- **SMTP_PASSWORD** Login for the mail
- **SMTP_SERVER** Mail server *smtp.gmail.com*
- **SMTP_RECIPIENTS** Comma seperated list of users for all information mails
- **SMTP_OPERATORS** Comma seperated list of users for all mails needing intervention

### Volumes
- **/etc/bareos**

### Configuration
This will create a sample configuration for Bareos using the templates given:
- bareos-dir: [Sample files](https://github.com/motius/dockerfiles/tree/master/bareos-dir/rootfs/temp/conf) mount to `/etc/bareos`

The container also takes care of setting some environment variables in the corresponding config files:
- Messages.conf
- Catalogs.conf

### Sample docker-compose.yml
```
version: "3"
services:
  # Bareos catalog
  postgres:
    container_name: bareos-db
    image: postgres:9-alpine
    environment:
      - "TIMEZONE=Europe/Berlin"
      - "LANG=C"
      - "POSTGRES_USER=bareos"
      - "POSTGRES_PASSWORD=bareos"
    volumes:
      - ./db:/var/lib/postgresql
    restart: always
    networks:
      - bareos

  # Bareos storage daemon
  bareos-sd:
    container_name: bareos-sd
    image: motius/bareos-sd
    environment:
      - "TIMEZONE=Europe/Berlin"
    volumes:
      - ./conf/bareos-sd:/etc/bareos
      - ./storage:/storage
    ports:
      - "9103:9103"
    restart: always
    networks:
      - bareos

  # BareOS file daemon
  bareos-fd:
    container_name: bareos-fd
    image: motius/bareos-fd
    environment:
      - "TIMEZONE=Europe/Berlin"
    volumes:
      - ./conf/bareos-fd:/etc/bareos
      - ./restore:/tmp/bareos-restores
    links:
      - postgres
    ports:
      - "9102:9102"
    restart: always
    networks:
      - bareos

  # Bareos director
  bareos-dir:
    container_name: bareos-dir
    image: motius/bareos-dir
    environment:
      - "TIMEZONE=Europe/Berlin"
      - "DB_HOST=postgres"
      - "DB_PASS=bareos"
      - "DB_NAME=bareos"
      - "DB_USER=bareos"
      - "DB_PORT=5432"
      - "SMTP_ACCOUNT=test@example.com"
      - "SMTP_FROM_ACCOUNT=test@example.com"
      - "SMTP_PASSWORD=pw123"
      - "SMTP_SERVER=smtp.gmail.com"
      - "SMTP_RECIPIENTS=test@example.com"
      - "SMTP_OPERATORS=test@example.com"
    volumes:
      - ./conf/bareos-dir:/etc/bareos
    ports:
      - 9101:9101
    links:
      - postgres
      - bareos-sd
      - bareos-fd
    restart: always
    networks:
      - bareos

  # Bareos webinterface
  bareos-ui:
    container_name: bareos-ui
    image: motius/bareos-ui
    restart: always
    volumes:
      - ./conf/bareos-ui:/etc/bareos-webui
    ports:
      - 80:80
    links:
      - bareos-dir
    networks:
      - bareos

networks:
  bareos:
```
