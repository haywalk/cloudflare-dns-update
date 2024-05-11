#!/bin/bash

# Hayden Walker, 2024-05-10
# 
# API documentation for updating a record: https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-update-dns-record
#
# See https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records for how to list your DNS records.
# This will allow you to find the record ID.


# api stuff
api="YOUR API KEY HERE"
zoneid="YOUR ZONE ID HERE"
recordid="YOUR DNS RECORD ID HERE (see comment for how to find)"

# preferences
domain="YOUR DOMAIN NAME HERE"
email="YOUR EMAIL HERE"
proxied="true"

# look up ip and date/time
myip=`curl -s "https://api.ipify.org"`
currdate=`date -Iminutes`

current=`curl --request GET \
  --url "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$recordid" \
  --header 'Content-Type: application/json' \
  --header "X-Auth-Email: $email" \
  --header "X-Auth-Key: $api" | python3 -c "import sys, json; print(json.load(sys.stdin)['result']['content'])"`

# only update if changed
if [ $current != $myip ]
then

# update record
curl --request PUT \
  --url "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$recordid" \
  --header 'Content-Type: application/json' \
  --header "X-Auth-Email: $email" \
  --header "X-Auth-Key: $api" \
  --data '{
  "content": "'$myip'",
  "name": "'$domain'",
  "proxied": '$proxied',
  "type": "A",
  "comment": "Automatically updated '$currdate'",
  "ttl": 3600
}'
fi
