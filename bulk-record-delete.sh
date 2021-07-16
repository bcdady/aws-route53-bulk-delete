#!/bin/bash
#Bulk delete records based on JSON output of route53-jq.sh files

zonename=$1
profile=$2
example=$(cat <<-END
./bulk-record-delete.sh [zonename] [profile]
ie ./bulk-record-delete.sh example.com myawsprofile
END)

if [ -z $zonename ] && [ -z $profile ]
then
  echo "zonename and profile required."
  echo "$example"
elif [ -z $zonename ]
then
  echo "zonename required."
  echo "$example"
elif [ -z $profile ]
then
  echo "profile required."
  echo "$example"
else
  hostedzoneid=$(aws route53 --profile $profile list-hosted-zones --output json | jq -r ".HostedZones[] | select(.Name == \"$zonename.\") | .Id" | cut -d'/' -f3)

  for file in x*; do
    aws route53 --profile $profile change-resource-record-sets \
    --hosted-zone-id=${hostedzoneid} \
    --change-batch=file://${file}
  done
fi
