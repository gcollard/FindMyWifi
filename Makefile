# Run every 2 minutes
2m:
	sudo SLEEP=120 ./main.sh
# Run every minute
1m:
	sudo SLEEP=60 ./main.sh
# Run every 5 minutes
5m:
	sudo SLEEP=300 ./main.sh
# Run every 10 minutes
10m:
	sudo SLEEP=600 ./main.sh
# Run every 30 minutes
30m:
	sudo SLEEP=1800 ./main.sh
dev:
debug:
	sudo SLEEP=0 ./main.sh
# Sign Apple Shortcut
build:
	echo "\033[1;32m[ACTION]\033[0m Click Add Shortcut"
	shortcuts sign --input getCoreLocationData.unsigned.wflow --output getCoreLocationData.wflow
	open getCoreLocationData.wflow