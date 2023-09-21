BEGIN { 
    OFS="\",\"";
    print "\"TS\",\"SSID\",\"BSSID\",\"RSSI\",\"CHANNEL\",\"HT\",\"CC\",\"SECURITY\""
}
NR>1 { 
    match($0, /[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}/)
    bssid = substr($0, RSTART, RLENGTH)
    SSIDREND = RSTART-2
    BSSIDRLENGTH = RLENGTH

    ssid = substr($0, 0, SSIDREND)
    gsub(/^[ \t]+/, "", ssid)
    $0 = substr($0, SSIDREND + BSSIDRLENGTH)
    
    match($0, /-?[0-9]+/)
    rssi = substr($0, RSTART, RLENGTH)
    $0 = substr($0, RSTART + RLENGTH)
    
    match($0, /[0-9,-]+/)
    channel = substr($0, RSTART, RLENGTH)
    gsub(/,-1/, "", channel)
    $0 = substr($0, RSTART + RLENGTH)
    
    match($0, /[[:space:]]Y[[:space:]]/)
    ht = substr($0, RSTART+1, 1)
    $0 = substr($0, RSTART + RLENGTH)
    
    match($0, /[[:space:]-]+[[:alpha:]]|\-{2}[[:space:]]/)
    cc = substr($0, RSTART+1, 2)
    $0 = substr($0, RSTART+3)
    
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)
    security = $0
    
    print "\""TS,ssid,bssid,rssi,channel,ht,cc,security"\""
    
}
