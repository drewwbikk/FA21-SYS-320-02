#!/bin/bash

# Storyline: Script to create a wireguard server

# Check for wg0.conf
if [[ -f "wg0.conf"  ]]
then

        # Prompt if we need to overwrite the file
        echo "The file wg0.conf already exists."
        echo -n "Do you want to overwrite it? [y|N] "
        read to_overwrite


        if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" ]]
        then

                echo "Exiting..."
                exit 0

        elif [[ "${to_overwrite}" == "y" ]]
        then
                echo "Creating the wireguard configuration file..."

        else
                echo "Invalid value"
                exit 1

        fi

fi

# Create a private key
p="$(wg genkey)"

# Create a public key
pub="$(echo ${p} | wg pubkey)"

# Set the addresses
address="10.254.132.0/24,172.16.28.0/24"

# Set Server IP addresses
serverAddress="10.254.132.1/24,172.16.28.1/24"

# Set Listening port
lport="4282"

# Create the format for the client configuration options
peerInfo="# ${address} 198.199.97.163:4282 ${pub} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"

# Template for server config file
: '
# 10.254.132.0/24,172.16.28.0/24 162.243.2.92:4282 ax8BVVCAtgASQ4XtOsaCGaQihW83JjZk5RgsK/mDIHU= 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0
[Interface]
Address = 10.254.132.1/24,172.16.28.1/24
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = 4282
Private Key = mDOoXx6HLWyrbdnoX3igK/PAy5vdAJDV2AUXZ2eFP0M=

'

echo "${peerInfo}
[Interface]
Address = ${serverAddress}
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = ${lport}
Private Key = ${p}
" > wg0.conf
