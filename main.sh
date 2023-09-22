#!/bin/zsh
# Main script to get network data out of airport service 
# and get location data out of CoreLocation service using the shortcut CLI tool
SLEEP="${SLEEP:-120}"  # sleep for 120 seconds if sleep isn't set
let "SLEEP_MINUTES = $SLEEP / 60"  # display sleep timer in minnutes
SLEEP_ERROR=60  # sleep timer when an error occurs
let "SLEEP_ERROR_MINUTES = $SLEEP_ERROR / 60"  # display sleep timer in minutes
COUNTER=0
COUNTER_ERROR=0
ERROR_RATE=0

echo "\033[1;32m[Start]\033[0m $(date) Scanning networks every ${SLEEP_MINUTES}min"

while true; do
    COUNTER=$((COUNTER+1))
    mkdir -p scans
    TIMESTAMP=$(date -u +%s)
    OUTPUT_NETWORKS_FILE="scans/$TIMESTAMP.networks.csv"
    OUTPUT_LOCATION_FILE="scans/$TIMESTAMP.location.json"
    touch $OUTPUT_NETWORKS_FILE
    touch $OUTPUT_LOCATION_FILE

    # Get Network data using airport
    # /!\ sudo is required to retrieve BSSID and country code
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s | awk -v TS=$TIMESTAMP -f airport_format_output.awk > $OUTPUT_NETWORKS_FILE
    airport_result=$?

    # Get location data using shortcut CLI tool
    # /!\ Wi-fi service should be up even if it's offline
    shortcuts run getCoreLocationData | TS=$TIMESTAMP python3 timestamp_add.py | json_pp -json_opt utf8,pretty > $OUTPUT_LOCATION_FILE
    shortcuts_result=$?

    if (( $shortcuts_result == 0 && $airport_result == 0))
    then
        # Success condition
        echo "\033[1;32m[Success]\033[0m $(date) waiting ${SLEEP_MINUTES}min before next scan"
        sleep ${SLEEP}
    elif (( $shortcuts_result == 255))
    then
        # Probably API Rate limit exceeded, try increasing sleep time
        let "COUNTER_ERROR = $COUNTER_ERROR + 1"
        let "ERROR_RATE = $COUNTER_ERROR / $COUNTER * 100"
        rm $OUTPUT_NETWORKS_FILE
        rm $OUTPUT_LOCATION_FILE
        echo "\033[1;31m[Error]\033[0m $(date) ${ERROR_RATE}% Error rate (${COUNTER_ERROR} err / ${COUNTER} try). If this number gets too high, consider increasing sleep time " >&2
        echo "\033[1;31m[Error]\033[0m $(date) restarting in ${SLEEP_ERROR_MINUTES}min" >&2
        sleep ${SLEEP_ERROR}
    else
        # other errors
        let "COUNTER_ERROR = $COUNTER_ERROR + 1"
        let "ERROR_RATE = $COUNTER_ERROR / $COUNTER * 100"
        rm $OUTPUT_NETWORKS_FILE
        rm $OUTPUT_LOCATION_FILE
        echo "\033[1;31m[Error]\033[0m $(date) Unexpected error, restarting in ${SLEEP_ERROR_MINUTES}min" >&2
        sleep ${SLEEP_ERROR}
    fi
done