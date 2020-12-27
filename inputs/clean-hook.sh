#!/bin/sh

echo "Cleaning for $CERTBOT_DOMAIN"

root_domain=$(echo -en $CERTBOT_DOMAIN | rev | cut -d . -f1,2 | rev)
rec_name=$(echo _acme-challenge.$CERTBOT_DOMAIN | sed 's/.'$root_domain'//g')

curl -s -D- -X DELETE -H "Content-Type: application/json" -H "X-Api-Key: $GANDI_APIKEY" https://dns.api.gandi.net/api/v5/domains/$root_domain/records/$rec_name/TXT > /dev/null
