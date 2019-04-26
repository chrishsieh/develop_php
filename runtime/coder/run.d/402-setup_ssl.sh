#!/usr/bin/env bash

set -e
set -u
set -o pipefail

for site_info_base64 in $(cat /var/run/secrets/ssl | jq -r '.[] | @base64'); do
    _jq() {
       echo ${1} | base64 -d | jq -r ${2}
    }

    ssl_mode=$(_jq ${site_info_base64} '.ssl')
    ssl_host=$(_jq ${site_info_base64} '.host')

    if [ -s "/certs/$(_jq ${site_info_base64} '.host').crt" ]; then
        if [[ "${ssl_mode}" != "none" ]]; then
            param="${CODESERVER_PARAMETER} --cert /certs/${ssl_host}.crt --cert-key /certs/${ssl_host}.key"
            export CODESERVER_PARAMETER="${param}"
        fi
    fi
done
