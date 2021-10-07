#!/bin/bash

# Storyline: Script to perform local security checks

function checks() {

	if [[ $2 != $3 ]]
	then

		echo -e "\e[1;31mThe $1 benchmark is not compliant. The policy should be $2 and the current value is $3.\e[0m"
		echo -e "\e[1;33mRemediation\n$4\e[0m"

	else

		echo -e "\e[1;32mThe $1 benchmark is compliant.\e[0m"

	fi

}

# Ensure IP forwarding is disabled
ip_forward_chk=$(sysctl net.ipv4.ip_forward | awk ' { print $3 } ')
checks "IP Forwarding" "0" "${ip_forward_chk}" "Edit /etc/sysctl.conf and set:\nnet.ipv4.ip_forward=1\nto\nnet.ipv4.ip_forward=0.\nThen run: \nsysctl -w net.ipv4.ip_forward=0\nsysctl -w net.ipv4.route.flush=1"

# Ensure ICMP redirects are not accepted
icmp_redirect_chk=$(sysctl net.ipv4.conf.all.accept_redirects | awk ' { print $3 } ')
checks "ICMP Redirects" "0" "${icmp_redirect_chk}" "Edit /etc/sysctl.conf and set:\nnet.ipv4.conf.all.send_redirects = 0\nnet.ipv4.conf.default.send_redirects = 0\nThen, run: \nsysctl -w net.ipv4.conf.all.send_redirects=0\nsysctl -w net.ipv4.conf.default.send_redirects=0\nsysctl -w net.ipv4.route.flush=1"

# Ensure permissions on /etc/crontab are configured
crontab_chk=$(stat /etc/cron.hourly | egrep '^Access: \(')
checks "Crontab Permissions" "Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)" "${crontab_chk}"  "Run the following commands:\nchown root:root /etc/crontab\nchmod og-rwx /etc/crontab"

# Ensure permissions on /etc/cron.hourly are configured
cronhourly_chk=$(stat /etc/cron.hourly | egrep '^Access: \(')
checks "Cronhourly Permissions" "Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)" "${cronhourly_chk}"  "Run the following commands:\nchown root:root /etc/cron.hourly\nchmod og-rwx /etc/cron.hourly"

# Ensure permissions on /etc/cron.daily are configured
crondaily_chk=$(stat /etc/cron.daily | egrep '^Access: \(')
checks "Cron.daily Permissions" "Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)" "${crondaily_chk}" "Run the following commands:\nchown root:root /etc/cron.daily\nchmod og-rwx /etc/cron.daily"

# Ensure permissions on /etc/cron.weekly are configured
cronweekly_chk=$(stat /etc/cron.weekly | egrep '^Access: \(')
checks "Cron.weekly Permissions" "Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)" "${cronweekly_chk}" "Run the following commands:\nchown root:root /etc/cron.weekly\nchmod og-rwx /etc/cron.weekly"

# Ensure permissions on /etc/cron.monthly are configured
cronmonthly_chk=$(stat /etc/cron.monthly | egrep '^Access: \(')
checks "Cron.monthly Permissions" "Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)" "${cronmonthly_chk}" "Run the following commands:\nchown root:root /etc/cron.monthly\nchmod og-rwx /etc/cron.monthly"

# Ensure permissions on /etc/passwd are configured
etcpasswd_chk=$(stat /etc/passwd | egrep '^Access: \(')
checks "/etc/passwd Permissions" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "${etcpasswd_chk}" "Run the following command:\nchmod 644 /etc/passwd"

# Ensure permissions on /etc/shadow are configured
etcshadow_chk=$(stat /etc/shadow | egrep '^Access: \(')
checks "/etc/shadow Permissions" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${etcshadow_chk}" "Run the following commands:\nchown root:shadow /etc/shadow\nchmod o-rwx,g-wx /etc/shadow"

# Ensure permissions on /etc/group are configured
etcgroup_chk=$(stat /etc/group | egrep '^Access: \(')
checks "/etc/group Permissions" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "${etcgroup_chk}" "Run the following commands:\nchown root:root /etc/group\nchmod 644 /etc/group"

# Ensure permissions on /etc/gshadow are configured
etcgshadow_chk=$(stat /etc/gshadow | egrep '^Access: \(')
checks "/etc/gshadow Permissions" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${etcshadow_chk}" "Run the following commands:\nchown root:shadow /etc/gshadow\nchmod o-rwx,g-rw /etc/gshadow"

# Ensure permissions on /etc/passwd- are configured
etcpasswdminus_chk=$(stat /etc/passwd- | egrep '^Access: \(')
checks "/etc/passwd- Permissions" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "${etcpasswdminus_chk}" "Run the following commands:\nchown root:root /etc/passwd-\nchmod u-x,go-wx /etc/passwd-"

# Ensure permissions on /etc/shadow- are configured
etcshadowminus_chk=$(stat /etc/shadow- | egrep '^Access: \(')
checks "/etc/shadow- Permissions" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${etcshadowminus_chk}" "Run the following commands:\nchown root:shadow /etc/shadow-\nchmod o-rwx,g-rw /etc/shadow-"

# Ensure permissions on /etc/group- are configured
etcgroupminus_chk=$(stat /etc/group- | egrep '^Access: \(')
checks "/etc/group- Permissions" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "${etcgroupminus_chk}" "Run the following commands:\nchown root:root /etc/group-\nchmod u-x,go-wx /etc/group"

# Ensure permissions on /etc/gshadow- are configured
etcgshadowminus_chk=$(stat /etc/gshadow- | egrep '^Access: \(')
checks "/etc/gshadow- Permissions" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${etcshadowminus_chk}" "Run the following commands:\nchown root:shadow /etc/gshadow-\nchmod o-rwx,g-rw /etc/gshadow-"

# Ensure no legacy "+" entries exist in /etc/passwd
legacyetcpasswd_chk=$(egrep '^\+:' /etc/passwd)
checks "Legacy /etc/passwd Entries" "" "${legacyetcpasswd_chk}" "Remove any legacy '+' entries from /etc/passwd."

# Ensure no legacy "+" entries exist in /etc/shadow
legacyetcshadow_chk=$(egrep '^\+:' /etc/shadow)
checks "Legacy /etc/shadow Entries" "" "${legacyetcshadow_chk}" "Remove any legacy '+' entries from /etc/shadow."

# Ensure no legacy "+" entries exist in /etc/group
legacyetcgroup_chk=$(egrep '^\+:' /etc/group)
checks "Legacy /etc/group Entries" "" "${legacyetcgroup_chk}" "Remove any legacy '+' entries from /etc/group."

# Ensure root is the only UID 0 account
rootuid_chk=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
checks "UID 0" "root" "${rootuid_chk}" "Remove any users other than root with UID 0 or assign them a new UID if appropriate."
