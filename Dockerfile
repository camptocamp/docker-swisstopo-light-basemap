# Builder image
FROM ubuntu:24.04 as builder
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
RUN echo "Download basemap mbtiles"
RUN wget https://vectortiles.geo.admin.ch/tiles/ch.swisstopo.base.vt/v1.0.0/ch.swisstopo.base.vt.mbtiles > /dev/null 2>&1
RUN echo "Download relief mbtiles"
RUN wget https://vectortiles.geo.admin.ch/tiles/ch.swisstopo.relief.vt/v1.0.0/ch.swisstopo.relief.vt.mbtiles > /dev/null 2>&1
RUN mkdir -p /pbf
RUN ./mbutil-master/mb-util --do_compression --image_format=pbf ch.swisstopo.base.vt.mbtiles /pbf/basemap
RUN ./mbutil-master/mb-util --do_compression --image_format=pbf ch.swisstopo.relief.vt.mbtiles /pbf/relief

# Runtime image
FROM openresty/openresty:1.21.4.3-2-jammy
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

ARG BUILD_DATE
ENV image_build_date=[Build_$BUILD_DATE]

COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template
RUN envsubst "\$image_build_date" < /etc/nginx/templates/nginx.conf.template > /usr/local/openresty/nginx/conf/nginx.conf

COPY default.conf /usr/local/openresty/nginx/conf/mvt/default.conf
COPY mvt.conf /usr/local/openresty/nginx/conf/mvt/mvt.conf
COPY templates /usr/share/nginx/html/
COPY lua /usr/local/openresty/nginx/lua
