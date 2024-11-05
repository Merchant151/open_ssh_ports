#!/bin/bash

#my goal for this script is to be run every hour in cron mode just to check on ssh status 
#Insuring ssh isn't randomly on.
#this script will also have a separate mode for standard run. It will be activated when mySsh is turned on. 
MODE='none'
while getopts ":cs" option; do
	case $option in 
		c)
			echo 'cron case'
			MODE='cron'
			;;
		s)
			echo 'standard case'
			MODE='standard'
			;;
		esac
	done

if [ $MODE == 'cron' ]
then 
	echo "cron mode" 
	#check if running if running exit 
	if myssh_status
	       exit	
	else
		echo 'myssh is not running'
		if shd_status 
			#sleepssh
			return 'this is an error'
		fi
	fi
	#if not running check sshd and myssh
	exit
elif [ $MODE == 'standard' ]
then 
	echo 'standard mode'
	#check if myssh is active 
	#check if sshd is active 
	#if sshd is active but myssh is inactive 
	#log issue and kill everything close ports
	while true 
	do 
		sleep 5m

	done
	exit
else
	echo 'no mode selected'
	exit	
fi


print_status


function print_status(){
	#include print status output
	systemctl status ufw 
	systemctl status fail2ban
	systemctl status ssh
	systemctl status sshd
}


function ufw_status(){
	systemctl is-active ufw >/dev/null 2>&1 && return 0 || return 1
}

function myssh_status(){
	result= "$ps aux | grep myssh | grep -v 'grep' | wc -l"
	#something like this? 
       return result	
}

function shd_status(){
	systemctl is-active ssh >/dev/null 2>&1 echo 'ssh inactive' || return 1
	systemctl is-active sshd >/dev/null 2>&1 return 0 || return 1
}

