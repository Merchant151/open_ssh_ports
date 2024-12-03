#!/bin/bash
#shibang 
TIME=0
#bin options (for now just time in hours)

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
echo 'I am being killed'
exit
}

trap murderProcess SIGINT SIGTERM

main(){
echo '---------------------'
echo WARNING SSH Ports will be opened and FIREWALL rules will be modified make sure you know what you are doing!
echo '---------------------'
#convert time to hours 
      #hiding sleep time to test in minutes for testing purposes
#SLEEP_TIME=$((TIME * 3600))
#check if time is an int or throw error 
echo running for $TIME hours
#run sentry
./sentry.sh -s 
#run sauron
./sauron.sh
#run start script 
echo 'pretending to wake'
./wakessh.sh 

#sleep for number of hours 
sleep $"SLEEP_TIME"
#run end script 
#todo turn this into a method and send results to .log file
./sleepssh.sh
ps -ef | grep sentry.sh | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep sauron.sh | grep -v grep | awk '{print $2}' | xargs kill
exit
}
test(){
echo '<MYSSH.sh>running for test'
./sentry.sh -t 
./sauron.sh
echo '<MYSSH.sh> pretending to wake'
SLEEP_TIME=$(($TIME * 1))
echo "<myssh> SLEEP_TIME EQUALS $SLEEP_TIME"

sleep $"SLEEP_TIME"
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
	test
	#main
fi 

