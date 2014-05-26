#! /bin/bash
#
# To make the init-script work properly don't rename this file and copy it to /mnt.
# Feel free to copy it somewhere else but then you have to adjust the init-script.

# VARIABLES
DEBUG=1 # 0 = false; 1 = true

SERVER_SCRIPT=1 # 0 = disable server; 1 = enable server (see /mnt/server for configuration)
SERVER_SCRIPT_PATH="/mnt/server"

VIDEO_PATH="/mnt/stream/"
PERMANENT_PATH="/mnt/perm/"

SAVEFILE="/mnt/saveme"

REAR_TAIL="_rear.avi"
FRONT_TAIL="_front.mpeg"

VIDEO_LENGTH=600 # 10 minutes
GPS_TRACKING_INTERVAL=15 #seconds

MINIMAL_FREE_SPACE="1048576" # 1 gb in kb

# CALLS
CAPTURE_REAR="echo ffmpeg -f video4linux2 -s 320x240 -t ${VIDEO_LENGTH} -i /dev/video0 ${VIDEO_PATH}"
CAPTURE_FRONT="echo raspivid -w 1280 -h 720 -t $(($VIDEO_LENGTH * 1000)) -o ${VIDEO_PATH}"

# FUNCTIONS
function validate {
    # Check if something is missing
    command -v ffmpeg >/dev/null 2>&1 || { echo >&2 "I require ffmpeg but it's not installed. Aborting."; exit 1; }
    command -v raspivid >/dev/null 2>&1 || { echo >&2 "I require raspivid but it's not installed. Aborting."; exit 1; }

    if [ ! -d "$VIDEO_PATH" ] || [ ! -d "$PERMANENT_PATH" ]
      then
        echo >&2 "Some paths are missing. Aborting."
        exit 1
    fi
}

function record_rear {
    # Start recording rear
    debug_out "recording rear.."
    ${CAPTURE_REAR}$(date +%s)${REAR_TAIL} > /dev/null 2>&1 &
    debug_out "rear chunk done.."
}

function record_front {
    # Start recording front
    debug_out "recording front.."
    ${CAPTURE_FRONT}$(date +%s)${FRONT_TAIL} > /dev/null 2>&1 &
    debug_out "front chunk done.."
}

function move_savefiles {
    # If $SAVEFILE is set, move last $VIDEO_LENGTH of recording to $PERMANENT_PATH
    if [ -f "$SAVEFILE" ]
      then
        # copy last files
        LASTREAR=$(ls -1t $VIDEO_PATH*$REAR_TAIL | head -2)
        LASTFRONT=$(ls -1t $VIDEO_PATH*$FRONT_TAIL | head -2)
        debug_out "moving $LASTREAR and $LASTFRONT to ${PERMANENT_PATH}.."
        mv $LASTREAR "$PERMANENT_PATH"
        mv $LASTFRONT "$PERMANENT_PATH"
        rm "$SAVEFILE"
    fi
}

function check_space {
    # Check if enough space is left on record device. If not, delete last records
    while [ $(df . | tail -n1 | awk '{print $4}') -lt $MINIMAL_FREE_SPACE ]
      do
        LASTREAR=$(ls -1tr $VIDEO_PATH*$REAR_TAIL | head -1)
        LASTFRONT=$(ls -1tr $VIDEO_PATH*$FRONT_TAIL | head -1)
        rm "$LASTREAR" "$LASTFRONT"
        debug_out "freeing space. Deleting $LASTREAR and $LASTFRONT.."
    done
}

function start_gps {
    # Start gps tracking
    debug_out "tracking gps.."
    # TODO: track gps
    sleep $GPS_TRACKING_INTERVAL
    start_gps
}

function debug_out {
    if [ $DEBUG == 1 ]
      then
        echo "$(date +%R): $1"
    fi
}

validate
start_gps &
while [ 1 ]
  do
    move_savefiles
    check_space
    record_rear
    record_front
    sleep $VIDEO_LENGTH
done
echo "something's wrong."
