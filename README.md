# FindMyWifi

Map all nearby wifi devices, their zone coverage and best estimate physical location.
### Use Cases
1. Index networking hardware on campus & pinpoint out of sight or lost equipment.
2. Find wifi deadzones on campus.
3. Track wifi able IOT devices using the geoNetwork database.

**Available features**: 
- Scan nearby wifi networks
- Get your GPS location
### Requirements
- **macOS** (airport tool to scan networks & shortcuts tool to get location)
- Download & install `getCoreLocationData` custom Apple Shortcut (https://www.icloud.com/shortcuts/0a02baf1db104091bf0fa5d328c93d8f)

> [!NOTE] Apple Shortcuts
> Shortcuts are custom snippets that can tap into low level OS APIs. In macOS the CoreLocation API allows us to get GPS data while offline and reverse geocode GPS coordinates.

### Usage
Clone this repo and execute with sudo.
```bash
sudo ./main.sh
```

> [!IMPORTANT] Why sudo?
> macOS limit network scanning data capabilities by default.  sudo is necessary to retrieve network devices' BSSID for identification purposes.

This command just glue everything together and output 2 files. 
1. `./scans/{time}.networks.csv` 
2. `./scans/{time}.location.json` 

##### Get GPS Coordinates
GPS coordinates and reverse geocoding can be obtain from Apple CoreLocation services. 
```bash
shortcuts run getCoreLocationData | json_pp -json_opt utf8,pretty
```

```output
{
   "altitude" : "59.00000000000000",
   "state" : "QC",
   "latitude" : "45.00000000000000",
   "city" : "Montréal",
   "longitude" : "-73.00000000000000",
   "postcode" : "XXX XXX",
   "region" : "Canada",
   "street" : "0000 Main Street"
}
```
##### Get Network Data
Network data is collected using the airport CLI tool which returns the following data

| SSID        | BSSID             | RSSI | CHANNEL | HT  | CC  | SECURITY (auth/unicast/group) |
| ----------- | ----------------- | ---- | ------- | --- | --- | --------------------------------- | 
| Router 2.4G | 01:ff:a0:a0:a0:a0 | -94  | 4       | Y   | CA  | RSN(PSK/AES/AES)                  |  
| TP-LINK_5G  | 02:ff:a0:a0:a0:a2 | -66  | 157     | Y   | US  | WPA(PSK/AES/AES) RSN(PSK/AES/AES) |  

###### Airport Output

**SSID** : Service Set Identifier; usually the user defined name of the wifi network or device.

**BSSID** : Basic Service Set Identifier; the device ID.

**RSSI** : (Received Signal Strength Indicator) RSSI provides an indication of the signal quality and can be used to determine how strong or weak the wireless connection is between devices. A higher RSSI value typically indicates a stronger signal.

**CHANNEL** : A specific frequency band the wireless device is emitting to.

**HT** : (High Throughput) is the wireless device compatible with the IEEE 802.11n standard which provides increased data transfer rates.

**CC** : ([Country Code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)) Wireless devices must adhere to the country code regulations to ensure compliance with local laws and spectrum management. The CC setting affects channel availability and transmit power limits.

**SECURITY** (auth/unicast/group):  
- Auth (Authentication): Authentication is the process of verifying the identity of a device or user before granting access to a wireless network.
- Unicast: Unicast security refers to the encryption and protection of data transmitted between a specific sender and receiver.
- Group: Group security refers to the encryption and protection of multicast or broadcast data that is sent to multiple recipients simultaneously.

### Roadmap
- [x] Scan Nearby Wifi Networks
- [x] Associate GPS data to Network scans
- [ ] cronjob setup.
- [ ] Pinpoint devices physical location over the map (highest RSSI or triangulation).
- [ ] Draw network coverage zones over the map.
- [ ] Add postgis
- [ ] API to perform geolocation from network data to GPS coordinates.
- [ ] Adapt to iOS/android for easier mobile scanning.