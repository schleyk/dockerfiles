FROM centos:7.2.1511

ENV REFRESHED_AT="2017-12-27" \
    BAREOS_DIR_CONF_FILE=bareos-dir.conf \
    DB_HOST="postgres" \
    DB_NAME="bareos" \
    DB_USER="bareos" \
    DB_PASS="bareos" \
    DB_PORT="5432" \
    BAREOS_DB_VERSION="2171"

RUN curl -Ls http://download.bareos.org/bareos/release/17.2/CentOS_7/bareos.repo \
    > /etc/yum.repos.d/bareos.repo \
  && yum -y install \
    git \
    bzip2 \
    bareos-director \
    bareos-database-tools \
    bareos-database-common \
    bareos-common \
    bareos-bconsole \
    bareos-tools \
    bareos-database-postgresql \
    jansson \
    libfastlz \
    lzo \
    postgresql-libs \
    postgresql \
    python-psycopg2 \
    openssl \
    mailx \
  && yum clean all

ADD rootfs /
EXPOSE 9101
VOLUME /etc/bareos

CMD ["/init"]
