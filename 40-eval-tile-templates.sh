#!/bin/bash -eu

export DOLLAR=$

find /usr/share/nginx/html/ -name '*.tmpl' -print | while read file

do
    echo "Evaluate: ${file}"
    envsubst < ${file} > ${file%.tmpl}
    if [ `id -u` == 0 ]
    then
        chmod --reference=${file} ${file%.tmpl}
        chown --reference=${file} ${file%.tmpl}
    fi
done

exec "$@"
