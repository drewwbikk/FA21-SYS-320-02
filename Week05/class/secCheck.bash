#!/bin/bash

# Storyline: Script to perform local security checks

function checks() {

	if [[ $2 != $3 ]]
	then

		echo -e "\e[1;31mThe $1 is not compliant. The policy should be: $2. The current value is: $3.\e[0m"

	else

		echo -e "\e[1;32mThe $1 is compliant. The current value is: $3.\e[0m"

	fi

}

# Check the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
# Check for password max
#               $1          $2       $3
checks "Password Max Days" "365" "${pmax}"

# Check the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Min Days" "14" "${pmin}"

# Check the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
checks "Password Warn Age" "7" "${pwarn}"

# Check the SSH UsePam configuration
chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePAM" "yes" "${chkSSHPAM}"

# Check permissions on users' home directories
echo ""
for eachDir in $(ls -l /home/ | egrep '^d' | awk ' { print $3 } ')
do

	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
	checks "Home Directory ${eachDir}" "drwx------" "${chDir}"

done
