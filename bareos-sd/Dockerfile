FROM centos:7.2.1511

ENV REFRESHED_AT="2017-12-27" \
    BAREOS_SD_CONF_FILE=bareos-sd.conf

RUN curl -Ls http://download.bareos.org/bareos/release/latest/CentOS_7/bareos.repo \
    > /etc/yum.repos.d/bareos.repo \
  && yum -y install \
    bareos-storage \
    openssl \
  && yum clean all

ADD rootfs /

EXPOSE 9103
VOLUME /storage
VOLUME /etc/bareos

CMD ["/init"]
