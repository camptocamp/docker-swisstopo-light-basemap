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
RUN wget --no-check-certificate https://github.com/mapbox/mbutil/archive/refs/heads/master.zip
RUN unzip master.zip
RUN wget --no-check-certificate https://vectortiles.geo.admin.ch/tiles/ch.swisstopo.leichte-basiskarte.vt/v1.0.0/ch.swisstopo.leichte-basiskarte.vt.mbtiles
RUN ./mbutil-master/mb-util --do_compression --image_format=pbf ch.swisstopo.leichte-basiskarte.vt.mbtiles /pbf

    # apt-get install --assume-yes --no-install-recommends gnupg ca-certificates && \
    # wget -O - https://openresty.org/package/pubkey.gpg | apt-key add - && \
    # echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/openresty.list && \
    # apt-get update && \
    # apt-get install --assume-yes --no-install-recommends openresty && \


#FROM nginx:1.21
FROM openresty/openresty:1.19.9.1-10-alpine-fat
COPY tiles /usr/share/nginx/html/tiles
COPY --from=builder /pbf /usr/share/nginx/html/tiles/pbf
RUN opm get bungle/lua-resty-template
COPY default.conf /etc/nginx/conf.d/default.conf
#RUN chmod 777 -R /var/cache/nginx/
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY templates /usr/share/nginx/html/
COPY lua /usr/local/openresty/nginx/lua
