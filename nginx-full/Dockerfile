FROM ubuntu
RUN     apt-get update &&\
        apt-get upgrade -y &&\
        DEBIAN_FRONTEND="noninteractive" apt-get install nginx-full -y &&\
        apt-get clean &&\
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
        && ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["nginx", "-g", "daemon off;"]
