#! /bin/bash
#
# Server-Script to communicate with Server and App

# VARIABLES
SERVER_DOMAIN="example.com" # domain and path only, don't add http/https!
SERVER_SECRET="secret" # server secret as configured in server script
SERVER_PROTOCOL="http" # http or https

SAVEFILE="/mnt/saveme"

# DON'T CHANGE ANYTHING AFTER THIS LINE
SERVER_BASE_URL="${SERVER_PROTOCOL}://${SERVER_DOMAIN}/?secret=${SERVER_SECRET}"

# FUNCTIONS
function validate {
    # Check if something is missing
    command -v curl >/dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Aborting."; exit 1; }
}

function check_set_save_flag {
    if [ $(curl -s "${SERVER_BASE_URL}&get=save") == "save" ]
      then
        touch "$SAVEFILE"
    fi
}

validate
while [ 1 ]
  do
    ping -c 1 "$SERVER_DOMAIN" > /dev/null 2>&1 && {
        # continue if server is reachable
        check_set_save_flag
    }
    sleep 60 # call the server every minute
done
echo "something's wrong."
