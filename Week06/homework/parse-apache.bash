#!/bin/bash

# Storyine: Parse Apache Log and Create IP Rulesets

# 81.19.44.12 - - [30/Sep/2018:06:26:55 -0500] "GET /console HTTP/1.1" 404 444 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0"

# Read in file
read -p "Please enter an apache log file." APACHE_LOG

# Check if the file exists
if [[ ! -f ${APACHE_LOG}  ]]
then
	echo "Specified file doesn't exist."
	exit 1
fi

# Looking for web scanners.
sed -e "s/\[//g" -e "s/\"//g" -e "s/\]//g" ${APACHE_LOG} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
sort -n | \
awk '!a[$1]++' | \
awk ' BEGIN { format = "%-15s %-45s %s\n" 
				printf format, "IP", "IPTables Ruleset", "Powershell Rule"
				printf format, "--", "----------------", "---------------" }

{ printf format, $1, "iptables -A INPUT -s "$1" -j DROP", "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - "$1" dir=in action=block remoteip="$1 } '
