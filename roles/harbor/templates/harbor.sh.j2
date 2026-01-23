#!/bin/bash
repos=("apache" "artifactory" "bitnami" "debian" "gitlab" "gitlab-runner" "gitlab-runner-helper" "httpd" "nginx" "postgres" "rockylinux" "ubuntu")
    ## Disable proxy for push
    curl -X PATCH "https://api.cloudflare.com/client/v4/zones/a753433c5cde8bf1bda6b23bc2147a74/dns_records/b7a8ff4395300f67c82b0b00524f3e87" \
    -H "Authorization: Bearer 6jbUG4_M4J5SUSJO6J_bMM6iTYkBZbosvfIz4Fxw" \
    -H "Content-Type: application/json" \
    --data '{"content": "superasian.net", "type": "CNAME", "name": "harbor.superasian.net", "proxied": false, "ttl": 3600, "tags": []}'
    for repo in ${repos[@]}; do
        ./$repo
    done
    ## Enable proxy after done
    curl -X PATCH "https://api.cloudflare.com/client/v4/zones/a753433c5cde8bf1bda6b23bc2147a74/dns_records/b7a8ff4395300f67c82b0b00524f3e87" \
    -H "Authorization: Bearer 6jbUG4_M4J5SUSJO6J_bMM6iTYkBZbosvfIz4Fxw" \
    -H "Content-Type: application/json" \
    --data '{"content": "superasian.net", "type": "CNAME", "name": "harbor.superasian.net", "proxied": true, "ttl": 3600, "tags": []}'
exit 0;
