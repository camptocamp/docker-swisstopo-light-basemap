# Builder image
FROM ubuntu:20.04 as builder
SHELL ["/bin/bash", "-o", "pipefail", "-cux"]
ENV \
    DEBIAN_FRONTEND=noninteractive \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
RUN \
    . /etc/os-release && \
    apt-get update && \
    apt-get --assume-yes upgrade && \
    apt-get install --assume-yes --no-install-recommends apt-utils && \
    apt-get install --assume-yes --no-install-recommends apt-transport-https && \
	apt-get install --assume-yes --no-install-recommends wget unzip python python3-pip python3-dev python3-wheel python3-pkgconfig libgraphviz-dev libpq-dev binutils gcc g++ cython3 && \
	apt-get clean
RUN wget https://github.com/mapbox/mbutil/archive/refs/heads/master.zip
RUN unzip master.zip
RUN wget https://vectortiles.geo.admin.ch/tiles/ch.swisstopo.leichte-basiskarte.vt/v2.0.0/ch.swisstopo.leichte-basiskarte.vt.mbtiles
RUN mkdir -p /pbf
RUN ./mbutil-master/mb-util --do_compression --image_format=pbf ch.swisstopo.leichte-basiskarte.vt.mbtiles /pbf/basemap

# Runtime image
FROM openresty/openresty:1.21.4.1-8-jammy
RUN \
    . /etc/os-release && \
    apt-get update && \
    apt-get --assume-yes remove --auto-remove --purge curl wget build-essential *-dev && \
    apt-get --assume-yes upgrade && \
    apt-get clean && \
    dpkg --force all --remove libsystemd0 libudev1
COPY tiles /usr/share/nginx/html/tiles
COPY --from=builder /pbf /usr/share/nginx/html/tiles/pbf
COPY template.lua /usr/local/openresty/site/lualib/resty/template.lua

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY default.conf /usr/local/openresty/nginx/conf/mvt/default.conf
COPY mvt.conf /usr/local/openresty/nginx/conf/mvt/mvt.conf
COPY templates /usr/share/nginx/html/
COPY lua /usr/local/openresty/nginx/lua
