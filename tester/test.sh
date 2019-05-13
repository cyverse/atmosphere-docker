#!/bin/bash

set -e

curl_cmd="curl -s -k -b cookie.txt"

# Get cookie and token
echo "Get cookie and token"
curl -k -c cookie.txt 'https://troposphere/login'
content=$($curl_cmd 'https://troposphere/application')
token=$(echo $content | grep -o -P '(?<=var access_token = ")[a-zA-Z0-9]*(?=")')

# Change guacamole_color color and check
echo "Change guacamole_color color and check"
$curl_cmd 'https://troposphere/api/v1/profile'\
  -X PATCH\
  -H 'Accept: application/json, text/javascript, */*; q=0.01'\
  -H 'Authorization: Token $token'\
  -H 'Content-Type: application/json'\
  --data '{"guacamole_color":"green_black"}' > /dev/null
response=$($curl_cmd 'https://troposphere/api/v1/profile'\
  -H 'Accept: application/json, text/javascript, */*; q=0.01'\
  -H 'Content-Type: application/json'\
  -H 'Authorization: Token $token')
[[ $(echo $response | jq -r '.guacamole_color') == "green_black" ]]
[[ $(echo $response | jq -r '.username') == "MockUser" ]]
echo "pass"

# Check that number of instances is 0
echo "Check that number of instances is 0"
response=$($curl_cmd 'https://troposphere/api/v2/instances?page_size=1000'\
  -H 'Accept: application/json, text/javascript, */*; q=0.01'\
  -H 'Content-Type: application/json'\
  -H 'Authorization: Token $token')
[[ $(echo $response | jq -r '.count') == 0 ]]
echo "pass"

# Check that number of volumes is 0
echo "Check that number of volumes is 0"
response=$($curl_cmd 'https://troposphere/api/v2/volumes?page_size=1000'\
  -H 'Accept: application/json, text/javascript, */*; q=0.01'\
  -H 'Content-Type: application/json'\
  -H 'Authorization: Token $token')
[[ $(echo $response | jq -r '.count') == 0 ]]
echo "pass"

# Check that number of projects is 0
echo "Check that number of projects is 0"
response=$($curl_cmd 'https://troposphere/api/v2/projects'\
  -H 'Accept: application/json, text/javascript, */*; q=0.01'\
  -H 'Content-Type: application/json'\
  -H 'Authorization: Token $token')
[[ $(echo $response | jq -r '.count') == 0 ]]
echo "pass"

# Check that number of allocation_sources is 0
echo "Check that number of allocation_sources is 0"
response=$($curl_cmd 'https://troposphere/api/v2/allocation_sources'\
  -H 'Accept: application/json, text/javascript, */*; q=0.01'\
  -H 'Content-Type: application/json'\
  -H 'Authorization: Token $token')
[[ $(echo $response | jq -r '.count') == 0 ]]
echo "pass"

# Check that number of identities is 0
echo "Check that number of identities is 0"
response=$($curl_cmd 'https://troposphere/api/v2/identities'\
  -H 'Accept: application/json, text/javascript, */*; q=0.01'\
  -H 'Content-Type: application/json'\
  -H 'Authorization: Token $token')
[[ $(echo $response | jq -r '.count') == 0 ]]
echo "pass"

# Check that number of providers is 0
echo "Check that number of providers is 0"
response=$($curl_cmd 'https://troposphere/api/v2/providers'\
  -H 'Accept: application/json, text/javascript, */*; q=0.01'\
  -H 'Content-Type: application/json'\
  -H 'Authorization: Token $token')
[[ $(echo $response | jq -r '.count') == 0 ]]
echo "pass"
