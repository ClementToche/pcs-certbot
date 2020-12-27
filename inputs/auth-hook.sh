#!/bin/sh
echo "Domain         : $CERTBOT_DOMAIN"
echo "Validation Str : $CERTBOT_VALIDATION"

root_domain=$(echo -en $CERTBOT_DOMAIN | rev | cut -d . -f1,2 | rev)
rec_name=$(echo _acme-challenge.$CERTBOT_DOMAIN | sed 's/.'$root_domain'//g')

echo "Root Domain    : $root_domain"
echo "Record Name    : $rec_name"

curl -D- -s -X POST -H "Content-Type: application/json" -H "X-Api-Key: $PCS_GANDI_APIKEY" \
	-d '{"rrset_name": "'$rec_name'",
             "rrset_type": "TXT",
	     "rrset_ttl": 3600,
	     "rrset_values": ["'$CERTBOT_VALIDATION'"]}' \
	https://dns.api.gandi.net/api/v5/domains/$root_domain/records > "/tmp/challenge_$CERTBOT_DOMAIN.tmp"

res=$(cat "/tmp/challenge_$CERTBOT_DOMAIN.tmp" | grep "201 Created")

if [ -z "$res" ]
then
	echo "Error ading TXT record for domain name"
	echo "Check /tmp/challenge_$CERTBOT_DOMAIN.tmp"
	exit 1
else
	echo "TXT record added"
fi

rm "/tmp/challenge_$CERTBOT_DOMAIN.tmp"

found=0
while [ $found -eq 0 ]
do
	res=$(host -t txt $rec_name.$root_domain | grep -- "$CERTBOT_VALIDATION")
	echo "$(host -t txt $rec_name.$root_domain)"
	echo "$CERTBOT_VALIDATION"
	if [ -z "$res" ]
	then
		echo "Waiting for TXT record to be made with res : $res"
	else
		echo "TXT Record found !"
		found=1
	fi
	sleep 5
done
