#!/bin/sh

APP_NAME="Jeapie"
VERSION="0.1"

TOKEN=""

URL="https://api.jeapie.com/v2/personal/send/message.json"
BROADCAST_URL="https://api.jeapie.com/v2/broadcast/send/message.json"
message=""
title=""
priority=0
isBroadcast=false

print_usage () {
    cat <<EOT
Usage:	<options> <message text>

Supported options:
    -k <token>          set token (required), also you can write token in the file
    -t <title>          set title (optional, default = "")
    -p <priority>       set priority (optional, default = 0)
    -b                  broadcast (optional, default is personal send)
EOT
}

print_version () {
    echo "$APP_NAME $VERSION"
}

# Option parsing
optstring="k:t:p:b"
while getopts ${optstring} c; do
    case ${c} in
        k)
            TOKEN="${OPTARG}"
            ;;
        t)
            title="${OPTARG}"
            ;;
        p)
            priority="${OPTARG}"
            ;;
        b)
            isBroadcast=true
            ;;
        [h\?])
            print_version
            print_usage
            exit 0
            ;;
    esac
done
shift $((OPTIND-1))

# Is there anything left?
if [ "$#" -lt 1 ]; then
    usage
fi
message="$*"

if [ "$TOKEN" = "" ]
then
    echo "Please, enter your token in the file or use -k option"
    print_usage
    exit 1
fi

if [ "$message" = "" ]
then
    echo "Please, enter your message"
    print_usage
    exit 1
fi

if [ "$isBroadcast" = "true" ]
then
    URL=$BROADCAST_URL
fi

curl $URL -F token="$TOKEN" -F message="$message" -F title="$title" -F priority="$priority"