#!/bin/bash
# Query AWS CLI for targeted domain zone and filter by ResourceRecords Value

zonename=$1
profile=$2
maxitems=$3
valuequery=$4
example=$(cat <<-END
./route53-jq.sh [zonename] [profile] [maxitems] [valuequery]
ie ./bulk-record-delete.sh example.com myawsprofile 100 1.1.1.1
END)

if [ -z $zonename ] && [ -z $profile ] && [ -z $maxitems] && [ -z $valuequery]
then
  echo "zonename, profile, maxitems, and valuequery required."
  echo "$example"
elif [ -z $zonename ]
then
  echo "zonename required."
  echo "$example"
elif [ -z $profile ]
then
  echo "profile required."
  echo "$example"
elif [ -z $maxitems ]
then
  echo "maxitems required."
  echo "$example"
elif [ -z $valuequery ]
then
  echo "valuequery required."
  echo "$example"
else
  hostedzoneid=$(aws route53 --profile $profile list-hosted-zones --output json | jq -r ".HostedZones[] | select(.Name == \"$zonename.\") | .Id" | cut -d'/' -f3)
  aws route53 --profile $profile list-resource-record-sets --hosted-zone-id $hostedzoneid --max-items $maxitems --output json | jq ".ResourceRecordSets[] | select(.ResourceRecords[]?.Value == \"$valuequery\")" | jq --compact-output '[{Action: "DELETE", ResourceRecordSet: {Name: .Name, Type: .Type, TTL: .TTL, ResourceRecords: .ResourceRecords}}] | _nwise(50) | {Changes: .}' | split -l 1
fi
