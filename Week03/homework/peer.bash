#!/bin/bash

# Storyline: Create peer VPN configuration file

if [[ $1 == "" ]]
then

	# What is the peer's name
	echo -n "What is the peer/client's name? "
	read the_client

else

	the_client="$1"

fi

# Filename variable
pFile="${the_client}-wg0.conf"

# Check for existing peer file
if [[ -f "${pFile}"  ]]
then

	#Prompt if we need to overwrite the file
	echo "The file ${pFile} already exists."
	echo -n "Do you want to overwrite it? [y|N] "
	read to_overwrite


	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" ]]
	then

		echo "Exiting..."
		exit 0

	elif [[ "${to_overwrite}" == "y" ]]
	then
		echo "Creating the wireguard configuration file..."

	# If the admin doesn't specify a y or N then error.
	else
		echo "Invalid value"
		exit 1

	fi

fi

# Generate private key
p="$(wg genkey)"

# Generate public key
clientPub="$(echo ${p} | wg pubkey)"

# Generate preshared key
pre="$(wg genpsk)"

# Endpoint
end="$(head -1 wg0.conf | awk ' { print $3 } ')"

# Server Public Key
pub="$(head -1 wg0.conf | awk ' { print $4 } ')"

# DNS servers
dns="$(head -1 wg0.conf | awk ' { print $5 } ')"

# MTU
mtu="$(head -1 wg0.conf | awk ' { print $6 } ')"

# KeepAlive
keep="$(head -1 wg0.conf | awk ' { print $7 } ')"

# ListenPort
lport="$(shuf -n1 -i 40000-50000)"

# Default routes for VPN
routes="$(head -1 wg0.conf | awk ' { print $8 } ')"

# Generate the IP address
tempIP=$(grep AllowedIPs wg0.conf | sort -u | tail -1 | cut -d\. -f4 | cut -d\/ -f1)
ip=$(expr ${tempIP} + 1)

# Create client configuration file

echo "[Interface]
Address = 10.254.132.${ip}/24
DNS = ${dns}
ListenPort = ${lport}
MTU = ${mtu}
PrivateKey = ${p}

[Peer]
AllowedIPs = ${routes}
PersistentKeepalive = ${keep}
PresharedKey = ${pre}
PublicKey = ${pub}
Endpoint = ${end}
" > ${pFile}

# Add peer configuration to server config
echo "

# ${the_client} begin
[Peer]
Publickey = ${clientPub}
PresharedKey = ${pre}
AllowedIPs = 10.254.132.${ip}/32
# ${the_client} end" >>  wg0.conf

# Other option besides >> is tee -a

: '
# Refresh configuration demonstration (per lab instructions)

echo "

sudo cp wg0.conf/etc/wireguard

sudo wg addconf wg0 <(wg-quick strip wg0)

"
'
