#! /bin/bash
#
# Server-Script to communicate with Server and App

# VARIABLES
SERVER_DOMAIN="example.com" # domain and path only, don't add http/https!
SERVER_PROTOCOL="http" # http or https

# FUNCTIONS
function validate {
    # Check if something is missing
    command -v curl >/dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Aborting."; exit 1; }
}

validate
while [ 1 ]
  do
    ping -c 1 "$SERVER_DOMAIN" > /dev/null 2>&1 && {
        # continue if server is reachable
        echo "ok"
    }
    sleep 60 # call the server every minute
done
echo "something's wrong."
