# docker-nginx-mvt

This docker image is a standalone MVT server for Swisstopo "leichte-basiskarte" MVT product.

The image is based on [openresty](https://openresty.org/en/) for the dynamic `style.json` and `tiles.json` rendering.

## Building

`docker build -t camptocamp/nginx-mvt:latest .`

## Run the server

### Default

`docker run -d -p 8080:8080 --name mvt camptocamp/nginx-mvt:latest`

### Parameters of the image

The templates can render any kind of url, the idea is that this server should be able to run behind some reverse proxies. The reverse proxies are supposed to provide the following request headers:

#### Request header when running behind a proxy

- X-Forwarded-Host: basically what should be in the `HOST` header
- X-Forwarded-Proto: "http" or "https"
- Forwarded-Path: any additional path between the host and the root of the service

#### At startup, via env variables

- VECTORTILES_PROTOCOL: "http" or "https"
- VECTORTILES_FQDN: basically what should be in the `HOST` header
- VECTORTILES_BASEURL: any additional path between the host and the root of the service
- SWISSTOPO_WMTS_HILLSHADE_URL: if the WMTS server for hillshade runs on the same server, put here the path that follows the `VECTORTILES_BASEURL` content.

#### example

```bash
docker run -d -p 8080:8080 \
  -e "SWISSTOPO_WMTS_HILLSHADE_URL=/geoserver/gwc/service/wmts/rest/workspace:ch.swisstopo.leichte-basiskarte_reliefschattierung/raster/EPSG:3857/EPSG:3857:{z}/{y}/{x}?format=image/png" \
  -e "VECTORTILES_FQDN=test.ch" \
   --name mvt camptocamp/nginx-mvt:latest
```
