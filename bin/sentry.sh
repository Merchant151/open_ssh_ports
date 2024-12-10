#!/bin/bash

sleep 10s
#my goal for this script is to be run every hour in cron mode just to check on ssh status 
#Insuring ssh isn't randomly on.
#this script will also have a separate mode for standard run. It will be activated when mySsh is turned on. 
MODE='none'
while getopts ":cst" option; do
	case $option in 
		c)
			echo 'cron case'
			MODE='cron'
			;;
		s)
			echo 'standard case'
			MODE='standard'
			;;
		t) 
			echo 'test mode'
			MODE='test'
		esac
	done

if [ $MODE == 'cron' ]
then
	cd "$(dirname "0")"
	D=date
	echo "cron mode running at $D" >> ../logs/sentry.log
	
	#check if running if running exit 
	#TODO LOG CRON MODE 
	if ps aux |grep -v grep|grep -q myssh.sh 
	then
		#TODO LOG DURRING CRON RUN myssh is cur running
		
		exit	
	else
		#TODO TURN THIS INTO A LOG
		echo 'myssh is not running'
		if shd_status 
			then
			./sleepssh.sh
			#TODO log ssh running without myssh
			D=date
			echo "Critical Failure ssh at $D status active myssh is not" >> ../logs/sentry.log

		fi
	fi
	#if not running check sshd and myssh
	exit
elif [ $MODE == 'standard' ]
then 
	#check if sshd is active 
	#if sshd is active but myssh is inactive 
	#log issue and kill everything close ports
	echo 'standard mode'
	while true 
	do 
	#check if myssh is active 
	if ps aux|grep -v grep|grep myssh.sh > /dev/null
	then
		#TODO change all ../ to use a paramterized location likely $dirname $0 in all program files
		D=date
		echo "Heartbeat at $D" >> ../logs/sentry.log
		pass
	else 
		#TODO log error of myssh inactive during standard mode
		./sleepssh
		ps -ef | grep sauron.sh | grep -v grep | awk '{print $2}' | xargs kill
		#TODO log sleeped and exiting standard mode
		exit
	fi

		sleep 5m

	done
	exit
elif [ $MODE == 'test' ]
then 
	echo '<SENTRY.sh>started in test mode' 
	if ps aux|grep -v grep|grep myssh > /dev/null ;then
		echo '<SENTRY.sh>myssh is currently running'
	else 
		echo '<SENTRY.sh>myssh is not running this would result in an error in standard mode'
	fi
	exit
else
	echo 'no mode selected'
	exit	
fi


#print_status


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
	systemctl is-active ssh >/dev/null 2>&1 && echo 'ssh inactive' || return 1
	systemctl is-active sshd >/dev/null 2>&1 && return 0 || return 1
}

