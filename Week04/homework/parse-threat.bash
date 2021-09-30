#!/bin/bash

# Storyline: Extract IPs from emergingthreats.net and create a firewall ruleset

while getopts 'icwmhu' OPTION ; do

	case "$OPTION" in

		i) iptables=${OPTION}
		;;
		c) cisco=${OPTION}
		;;
		w) windows=${OPTION}
		;;
		m) mac=${OPTION}
		;;
		u) url=${OPTION}
		;;
		h)

			echo ""
			echo "Usage: $(basename $0) [-i]|[-c]|[-w]|[-m]|[-u]"
			echo ""
			exit 1

		;;
		*)

			echo "Invalid value."
			exit 1

		;;
	esac
done

# Check to see an option is provided
if [[ ${iptables} == "" && ${cisco} == "" && ${windows} == "" && ${mac} == "" && ${url} == "" ]]
then
	echo "Please specify -i, -c, -w, -m, or -u"
	exit 1
fi


# Check for emerging threats file

if [[ -f "/tmp/emerging-compromised.rules" ]]
then

	# Prompt is we need to overwrite the file
	echo "The file emerging-compromised.rules already exists."
	echo -n "Do you want to overwrite it? [y|N] "
	read to_overwrite

	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" ]]
	then

		echo "Exiting"

	elif [[ "${to_overwrite}" == "y"  ]]
	then

		echo "Downloading the emerging-compromised.rules file..."
		wget https://rules.emergingthreats.net/blockrules/emerging-compromised.rules -O /tmp/emerging-compromised.rules

	else

		echo "Invalid value."
		exit 1

	fi

fi

# Download file
# wget https://rules.emergingthreats.net/blockrules/emerging-compromised.rules -O /tmp/emerging-compromised.rules

# Parse bad IPs
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /tmp/emerging-compromised.rules | sort -u | tee badIPs.txt



# Create iptables rules
if [[ ${iptables} ]]
then

	for eachIP in $(cat badIPs.txt)
	do

		echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables

	done
fi

if [[ ${cisco} ]]
then

	for eachIP in $(cat badIPs.txt)
	do

		echo "access-list 1 deny host ${eachIP}" | tee -a cisco.rules

	done
fi

if [[ ${windows} ]]
then

	for eachIP in $(cat badIPs.txt)
	do

		echo "netsh advfirewall add rule name=BlockIP dir=in interface=any action=block remoteip=${eachIP}" | tee -a windows.rules

	done
fi

if [[ ${mac} ]]
then

	for eachIP in $(cat badIPs.txt)
	do

		echo "block in from ${eachIP} to any" | tee -a pf.conf

	done
fi

if [[ ${url} ]]
then

	# wget raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv

	egrep "domain" /tmp/targetedthreats.csv | sort -u | cut -d\" -f4 | tee badURLs.txt

	echo "class-map match-any BAD_URLS" | tee -a url.filters

	for eachURL in $(cat badURLs.txt)
	do

		echo "match protocol http host "${eachURL}"" | tee -a url.filters

	done
fi

