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
	B=$(pwd)
	bash -c "cd "$(dirname "0")""
	D=$(date)
	P=$(pwd)
	echo "cron mode running at $D" >> /home/merchant/Documents/projects/git/ssh/open_ssh_ports/logs/sentry.log
	echo "cron mode running with working directory $P (after)" >> /home/merchant/Documents/projects/git/ssh/open_ssh_ports/logs/sentry.log
	echo "cron mode running with working directory $B (before)" >> /home/merchant/Documents/projects/git/ssh/open_ssh_ports/logs/sentry.log
	
	#check if running if running exit 
	if ps aux |grep -v grep|grep -q myssh.sh 
	then
		echo "durring cron run discovered myssh is running" >> ../logs/sentry.log	
		exit	
	else
		echo 'myssh is not running' >> ../logs/sentry.log
		if shd_status 
			then
			./sleepssh.sh #this can only be acomplished as root so job must be under root cron 
			D=$(date)
			echo "Critical Failure ssh at $D status active myssh is not" >> ../logs/sentry.log

		fi
	fi
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
		D=$(date)
		echo "Heartbeat at $D" >> ../logs/sentry.log
		pass
	else 
		D=$(date)
		echo "$D myssh is now showing as active Sentry executing sleep!" >> ../logs/sentry.log
		./sleepssh
		ps -ef | grep sauron.sh | grep -v grep | awk '{print $2}' | xargs kill
		D=$(date)
		echo "<SENTRY> $D sleeped and exiting" >> ../logs/sauron.log
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

