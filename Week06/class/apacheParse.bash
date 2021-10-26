#!/bin/bash

# Storyine: Parse Apache Log and Create IP Rulesets

# 81.19.44.12 - - [30/Sep/2018:06:26:55 -0500] "GET /console HTTP/1.1" 404 444 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0"

# Read in file

# Arguments using the position, they start at $1
APACHE_LOG="$1"

# Check if the file exists

if [[ ! -f ${APACHE_LOG}  ]]
then
	echo "Please specify the path to a log file."
	exit 1
fi

# Looking for web scanners.
sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk ' BEGIN { format = "%-15s %-20s %-7s %-6s %-10s %s\n" 
				printf format, "IP", "Date", "Method", "Status", "Size", "URI"
				printf format, "--", "----", "------", "------", "----", "---" }

{ printf format, $1, $4, $6, $9, $10, $7 } '
