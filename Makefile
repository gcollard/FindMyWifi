# Sign Apple Shortcut
build:
	echo "Click Add Shortcut"
	shortcuts sign --input getCoreLocationData.unsigned.wflow --output getCoreLocationData.wflow
	open getCoreLocationData.wflow
	rm getCoreLocationData.unsigned.wflow