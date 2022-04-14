
local template = require "resty.template"
-- local template_string = ngx.location.capture(ngx.var.templateFile)


hostname = ngx.req.get_headers()['X-Forwarded-Host']
if hostname == nil then
    hostname = ngx.req.get_headers()['Host']
end

proto = ngx.req.get_headers()['X-Forwarded-Proto']
if proto == nil then
    proto = "http"
end

baseurl = ngx.req.get_headers()['Forwarded-Path']
if baseurl == nil then
    baseurl = ""
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
        BASEURL = baseurl
    },
    "no-cache"
    )
