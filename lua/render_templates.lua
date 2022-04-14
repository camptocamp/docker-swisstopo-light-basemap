
local template = require "resty.template"
-- local template_string = ngx.location.capture(ngx.var.templateFile)

hostname = os.getenv("VECTORTILES_FQDN")
if hostname == nil then
    hostname = ngx.req.get_headers()['X-Forwarded-Host']
end
if hostname == nil then
    hostname = ngx.req.get_headers()['Host']
end

proto = os.getenv("VECTORTILES_PROTOCOL")
if proto == nil then
    proto = ngx.req.get_headers()['X-Forwarded-Proto']
end
if proto == nil then
    proto = "http"
end

baseurl = os.getenv("VECTORTILES_BASEURL")
if baseurl == nil then
    baseurl = ngx.req.get_headers()['Forwarded-Path']
end
if baseurl == nil then
    baseurl = ""
end
-- sanitize a bit
if string.sub(baseurl,string.len(baseurl))=="/" then
    baseurl = string.sub(baseurl,0, string.len(baseurl)-1)
end

template_file_name = ngx.var.templateFile
if template_file_name == "" then
    template_file_name = "index.html"
end

wmts_hillshade_url = os.getenv("SWISSTOPO_WMTS_HILLSHADE_URL")
if wmts_hillshade_url == nil then
    wmts_hillshade_url = "https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.leichte-basiskarte_reliefschattierung/default/current/3857/{z}/{x}/{y}.png"
end


template.render(
    template_file_name, {
        PROTOCOL = proto,
        HOSTNAME = hostname,
        BASEURL = baseurl,
        SWISSTOPO_WMTS_HILLSHADE_URL = wmts_hillshade_url
    },
    "no-cache"
    )
