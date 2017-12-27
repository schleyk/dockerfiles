# BareOS Director
![](https://www.bareos.com/files/Logos/Bareos/Logo_gesamt.png)

![](https://img.shields.io/docker/pulls/motius/bareos-dir.svg) ![](https://img.shields.io/github/commit-activity/y/motius/dockerfiles.svg) ![](https://img.shields.io/github/issues/motius/dockerfiles.svg) ![](https://img.shields.io/docker/automated/motius/bareos-dir.svg)
![](https://img.shields.io/docker/build/motius/bareos-dir.svg)

Based on https://github.com/shoifele/bareos-dir
## Features
- Automatic generation of template config
- Creation or migration of the database (catalog)
- Mail handling

## Sample docker-compose

```
version: "2"
services:
  # Bareos catalog
  postgres:
    container_name: bareos-db
    image: postgres:9-alpine
    environment:
      - "TIMEZONE=Europe/Berlin"
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
      TIMEZONE: Europe/Berlin
      DB_HOST: postgres
      DB_PASS: bareos
      DB_NAME: bareos
      DB_USER: bareos
      DB_PASS: bareos
      DB_PORT: 5432
      SMTP_ACCOUNT: test@example.com"
      SMTP_FROM_ACCOUNT: test@example.com
      SMTP_PASSWORD: pw123
      SMTP_SERVER: smtp.gmail.com
      SMTP_RECIPIENTS: test@example.com
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
      - ./init:/init
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

This will create a sample configuration for Bareos using the templates given:
- bareos-dir: [Sample files](https://github.com/motius/dockerfiles/tree/master/bareos-dir/rootfs/temp/conf) mount to `/etc/bareos`
- bareos-fd: [Sample files](https://github.com/motius/dockerfiles/tree/master/bareos-fd/rootfs/temp) mount to `/etc/bareos`
- bareos-sd: [Sample files](https://github.com/motius/dockerfiles/tree/master/bareos-sd/rootfs/temp) mount to `/etc/bareos`
- bareos-ui: [Sample files](https://github.com/motius/dockerfiles/tree/master/bareos-sd/rootfs/temp) mount to  `/etc/bareos-webui`

The container also takes care of setting some environment variables in the corresponding config files:
- Messages.conf
- Catalogs.conf