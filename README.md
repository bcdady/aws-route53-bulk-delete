# aws-route53-bulk-delete
bash scripts using AWS CLI and JQ to bulk delete Route53 entries

This is based off of the ReleaseHub article titled ["How to Delete Hundreds or Thousands of Route53 DNS Entries"](https://releasehub.com/blog/how-to-delete-hundreds-or-thousands-of-route53-dns-entries) by Regis Wilson.

## Usage

We assume you have [AWS CLI Profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) setup

First script will query the AWS CLI for ResourceRecords and split them into individual files.
```
./route53-jq.sh [zonename] [profile] [maxitems] [valuequery]

./route53-jq.sh example.com myawsprofile 100 1.1.1.1
```
Next script will loop through all files and run the output JSON against the AWS CLI
```
./bulk-record-delete.sh example.com myawsprofile
```
