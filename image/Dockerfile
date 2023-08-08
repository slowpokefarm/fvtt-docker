FROM ubuntu:22.04
MAINTAINER Stanislav Slow <stanislav.rimsha@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# make directory
RUN mkdir -p /var/foundry/fvtt
RUN mkdir -p /var/foundry/data

# Build-arg: User ID for the created foundry user
ENV UID=1026
# Build-arg: Group ID for the created group
ENV GUID=65534
# Set the foundry install home
ENV FOUNDRY_HOME=/var/foundry/fvtt

# RUN echo "UID ${UID}"
# add a foundry group with a guid listed above

# RUN echo "UID: ${UID} GUID: $GUID"
# create the foundry user
# RUN adduser -u $UID -h "$FOUNDRY_HOME" -D foundry

# installing unzip and bash shell
RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository universe && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get update  && \
    apt-get install -y \
    git \
    mc \
    curl \
    unzip \
    cron \
    apt-utils \
    wget \
    nano \
    supervisor \
    htop \
    language-pack-ru \
    certbot \
    nginx && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean

RUN chown -R root:root /etc/cron.d && \
    chmod -R 0644 /etc/cron.d

COPY service.sh /

RUN chmod 700 /service.sh

# Set the current working directory
WORKDIR "${FOUNDRY_HOME}"

# curl nodejs nginx unzip
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get -y install nodejs

# copy found
COPY ./foundryvtt*.zip .

# unzip 
RUN unzip foundryvtt*.zip
RUN rm foundryvtt*.zip


RUN mkdir /run/php/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    sed -i "s/user www-data;/user root;/" /etc/nginx/nginx.conf && \
    sed -i "s/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;\n        client_max_body_size 100M;/" /etc/nginx/nginx.conf

# Supervisor conf
RUN echo "[supervisord]" >> /etc/supervisor/supervisord.conf && \
    echo "nodaemon = true" >> /etc/supervisor/supervisord.conf && \
    echo "user = root" >> /etc/supervisor/supervisord.conf

RUN echo "[program:cron]" >> /etc/supervisor/supervisord.conf && \
    echo "command = cron -f" >> /etc/supervisor/supervisord.conf && \
    echo "autostart = true" >> /etc/supervisor/supervisord.conf && \
    echo "autorestart = true" >> /etc/supervisor/supervisord.conf && \
    echo "[program:nginx]" >> /etc/supervisor/supervisord.conf && \
    echo "command = /usr/sbin/nginx" >> /etc/supervisor/supervisord.conf && \
    echo "autostart = true" >> /etc/supervisor/supervisord.conf && \
    echo "autorestart = true" >> /etc/supervisor/supervisord.conf && \
    mkdir /var/log/app && \
    chmod -R 0644 /var/log/app

EXPOSE 30000

WORKDIR "/"

CMD ["./service.sh"]
