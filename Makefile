# Sign Apple Shortcut
build:
	echo "Click Add Shortcut"
	shortcuts sign --input getCoreLocationData.unsigned.wflow --output getCoreLocationData.wflow
	open getCoreLocationData.wflow
	rm getCoreLocationData.unsigned.wflow
# Run every minute
1m:
	sudo SLEEP=60 ./main.sh
# Run every 2 minutes
run:
	sudo SLEEP=120 ./main.sh
# Run every 5 minutes
5m:
	sudo SLEEP=300 ./main.sh
# Run every 10 minutes
10m:
	sudo SLEEP=600 ./main.sh
# Run every 30 minutes
30m:
	sudo SLEEP=1800 ./main.sh