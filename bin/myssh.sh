#!/bin/bash
TIME=0
#bin options (for now just time in hours)
#cd "$(dirname "$0")"
#SCRIPT_DIR="$(pwd)"
SCRIPT_DIR="$(dirname "$0")"
#running as root for now since I am configuring system processes hope this doesn't create issues
#sudo su

#help option
usage(){
	#The purpose of this script
	#options of this script include
	#-h show script usage
	# others 
	echo '--------------'
	echo 'myssh.sh is the entrypoint for Marts OpenSSH project. Run myssh to open ports and activate sshd'
	echo 'options:' 
	echo '     -t time to run option'
	echo '     -h help function'
	echo ' usage> myssh.sh -t 1' 
	echo ' to run the script for one hour'

}

#catch term out and run stop script
murderProcess(){
echo '<myssh> I am being untimely killed'
$SCRIPT_DIR/sleepssh.sh
ps -ef | grep sentry.sh | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep sauron.sh | grep -v grep | awk '{print $2}' | xargs kill
exit
}

trap murderProcess SIGINT SIGTERM

main(){
echo '---------------------'
echo WARNING SSH Ports will be opened and FIREWALL rules will be modified make sure you know what you are doing!
echo '---------------------'
#convert time to hours 
SLEEP_TIME=$((TIME * 3600))
echo "running for $TIME hours"
#run sentry
$SCRIPT_DIR/sentry.sh -s & 
#run sauron 
$SCRIPT_DIR/sauron.sh & 
#run start script 
echo '<myssh.sh> RUNNING WAKE'
$SCRIPT_DIR/wakessh.sh 

#sleep for number of hours 
sleep $SLEEP_TIME
#run end script 
#todo turn this into a method and send results to .log file
echo '<myssh.sh> trying to sleepssh and kill sentry/sauron scripts'
$SCRIPT_DIR/sleepssh.sh
ps -ef | grep sentry.sh | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep sauron.sh | grep -v grep | awk '{print $2}' | xargs kill
exit
}
test(){
echo '<MYSSH.sh>running for test'
$SCRIPT_DIR/sentry.sh -t &  
$SCRIPT_DIR/sauron.sh & 
echo -n 'trying to echo path: '
echo "$(dirname $0)"
echo '' #adding new line
echo "SCRIPT DIRECTORY : $SCRIPT_DIR"

echo '<MYSSH.sh> pretending to wake'
SLEEP_TIME=$(($TIME * 1))
echo "<myssh> SLEEP_TIME EQUALS $SLEEP_TIME"

sleep $SLEEP_TIME
ps -ef | grep sentry.sh | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep sauron.sh | grep -v grep | awk '{print $2}' | xargs kill
}

while getopts ":ht:" option; do
	case $option in 
		h)
			usage
			exit;;
		t)
			echo "option time set to $OPTARG hours" 
			TIME=$OPTARG
			re='^[0-9]+$' #regular expression has to be separate line for proper interpretation
			if ! [[ $TIME =~ $re ]] ; then
				#echo $TIME
				echo 'error option t not a valid number'
				exit 1
			fi 
			#main
			#test
			;;
		\?)
			echo 'incorrect option selected'
			usage
			exit;;
		:)
			echo 'no options selected'
			usage
			exit;;
		esac
	done

if [ $# -eq 0 ]; then 
	echo "No args passed"
	usage
	exit
else 
	#test
	main
fi 

