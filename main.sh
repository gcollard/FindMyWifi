#!/bin/zsh

# Main script to get network data out of airport service 
# and get location data out of CoreLocation service using the shortcut CLI tool
echo "$(date)"
mkdir -p scans
TIMESTAMP=$(date -u +%s)
OUTPUT_NETWORKS_FILE="scans/$TIMESTAMP.networks.csv"
OUTPUT_LOCATION_FILE="scans/$TIMESTAMP.location.json"
touch $OUTPUT_NETWORKS_FILE
touch $OUTPUT_LOCATION_FILE

# Get Network data using airport
# /!\ sudo is required to retrieve BSSID and country code
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s | awk -v TS=$TIMESTAMP -f airport_format_output.awk > $OUTPUT_NETWORKS_FILE

# Get location data using shortcut CLI tool
# /!\ Wi-fi service should be up even if it's offline
shortcuts run getCoreLocationData | TS=$TIMESTAMP python timestamp_add.py | json_pp -json_opt utf8,pretty > $OUTPUT_LOCATION_FILE
