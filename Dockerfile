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

FROM nginx:1.21
ENV VECTOR_TILES_FQDN="http://localhost:8080"
ENV VECTOR_TILES_BASEURL=""
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY tiles /usr/share/nginx/html/tiles
RUN chmod 777 /usr/share/nginx/html/tiles
RUN chmod 777 -R /var/cache/nginx/
COPY --from=builder /pbf /usr/share/nginx/html/tiles/pbf
COPY 40-eval-tile-templates.sh /docker-entrypoint.d
