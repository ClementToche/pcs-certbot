#!/bin/sh

set -e

pcs-logger info '--------------------------------------------------'
pcs-logger info "Personal Cloud Server - Let's Encrypt Service     "
pcs-logger info '--------------------------------------------------'
pcs-logger info 'tls GID'
pcs-logger info '--------------------------------------------------'
pcs-logger info "User gid:    $(getent group tls | cut -d ':' -f 3)"
pcs-logger info '--------------------------------------------------'

if [ "$1" == "force" ] || [ -z "$(certbot certificates 2>/dev/null | grep 'Found the following certs')" ]
then
    certbot certonly --force-renewal --preferred-challenges dns --manual \
    --domains ${PCS_CERTBOT_DOMAIN_LIST} \
    --manual-auth-hook /etc/certbot/auth-hook.sh \
    --manual-cleanup-hook /etc/certbot/clean-hook.sh \
    -m ${PCS_CERTBOT_EMAIL_REGISTER} \
    --agree-tos \
    -n
else
    echo "renew"
    certbot renew
fi

chown -R root:tls /etc/letsencrypt/archive/ /etc/letsencrypt/live/
chmod 750 /etc/letsencrypt/archive/ /etc/letsencrypt/live/
chmod 640 /etc/letsencrypt/archive/*/privkey*