#!/bin/bash

# Fetch the METAR data from the NOAA API and store it in a file called aviation.json
curl -s "https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" > aviation.json

# Parse the receiptTime values (the date/time of the observation) and output the first 6
echo "First 6 Receipt Times:"
jq -r '.[0:6] | .[].receiptTime' aviation.json

# Parse the temperatures and calculate the average temperature across the 12 hours
temp_sum=$(jq '[.[] | .temp] | add' aviation.json)
temp_count=$(jq '[.[] | .temp] | length' aviation.json)

if [ "$temp_count" -gt 0 ]; then
  average_temp=$(echo "scale=2; $temp_sum / $temp_count" | bc)
  echo "Average Temperature: $average_temp"
else
  echo "No temperature data available."
fi

# Parse the cloud data and determine if more than half of the last 12 hours were cloudy (not CLR)
cloudy_count=$(jq '[.[] | select(.clouds | any(.cover != "CLR"))] | length' aviation.json)
total_count=$(jq 'length' aviation.json)

if [ "$cloudy_count" -gt "$((total_count / 2))" ]; then
  echo "Mostly Cloudy: true"
else
  echo "Mostly Cloudy: false"
fi

