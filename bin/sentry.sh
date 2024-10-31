#!bin/bash

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
