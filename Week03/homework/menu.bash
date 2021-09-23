#!/bin/bash

# Storyline: Menu for admin, VPN, and Security functions

function invalid_opt() {

	echo ""
	echo "Invalid option"
	echo ""
	sleep 2

}

function menu() {

	# clears the screen
	clear

	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		1) admin_menu
		;;

		2) security_menu
		;;

		3) exit 0

		;;
		*)

			invalid_opt
			# Call the main menu
			menu

		;;
	esac


}

function admin_menu() {

	clear
	echo "[L]ist Running Processes"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		L|l) ps -ef | less
		;;
		N|n) netstat -an --inet | less
		;;
		V|v) vpn_menu
		;;
		4) exit 0
		;;

		*)
			invalid_opt
		;;

	esac

admin_menu
}

function vpn_menu() {

	clear
	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[C]heck for an existing peer"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit"
	read -p "Please select an option: " choice

	case "$choice" in

		A|a)

			bash peer.bash
			tail -6 wg0.conf | less

		;;
		D|d)
			# Create a prompt for the user
			read -p "What is the name of the peer you wish to delete? " peer_delete
			# Call the manage-user.bash and pass the proper switches and argument
			# to delete the user.
			bash manage-users.bash -d -u $peer_delete
			sleep 3
		;;
		C|c)
			# Create a prompt for the user
			read -p "What is the name of the peer to check for? " peer_check
			# Checks for an existing peer with the name of $peer_check in wg0.conf
			if grep -q "$peer_check begin" wg0.conf
			then
				echo "$peer_check is an existing peer."
				sleep 3
			else
				echo "$peer_check is not an existing peer."
				sleep 3
			fi
		;;
		B|b) admin_menu
		;;
		M|m) menu
		;;
		E|e) exit 0
		;;
		*)
			invalid_opt
		;;

	esac

vpn_menu
}

function security_menu() {

        clear
        echo "[O]pen Network Sockets"
        echo "[U]ID Check"
        echo "[L]ast 10 logged in users"
	echo "[C]urrently logged in users"
        echo "[E]xit"
        read -p "Please enter a choice above: " choice

        case "$choice" in

                O|o) ss -l | less
                ;;
                U|u)
			echo "The following users have a UID of 0:" 
			cat /etc/passwd | awk -F: '($3 == 0) { print $1 }'
			sleep 3
		;;
                L|l) last -n 10 | less
		;;
		C|c) who | less
		;;
                E|e) exit 0
                ;;

                *)
                        invalid_opt
                ;;

        esac

security_menu
}

# Call the main function
menu
