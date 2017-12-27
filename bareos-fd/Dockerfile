FROM centos:7.2.1511

ENV REFRESHED_AT="2017-12-27" \
    BAREOS_FD_CONF_FILE=bareos-fd.conf

RUN curl -Ls http://download.bareos.org/bareos/release/latest/CentOS_7/bareos.repo \
    > /etc/yum.repos.d/bareos.repo \
  && yum -y localinstall http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm  \
  && yum -y install \
    git \
    openssl \
    ca-certificates \
    bareos-client \
    postgresql95 \
    sshfs \
    cifs-utils \
    openssl \
    bzip2 \
  && yum clean all

ADD rootfs /

EXPOSE 9102
VOLUME /etc/bareos

CMD ["/init"]
