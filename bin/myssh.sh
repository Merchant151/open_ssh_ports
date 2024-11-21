#!/bin/bash
#shibang 
TIME=1
#bin options (for now just time in hours)
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
		esac
	done

#help option
usasge(){
	#The purpose of this script
	#options of this script include
	#-h show script usage
	# others 
	echo 'none'	
}

#catch term out and run stop script
murderProcess(){
echo 'I am being killed'
exit
}

trap murderProcess SIGINT SIGTERM

#convert time to hours 
      #hiding sleep time to test in minutes for testing purposes
#SLEEP_TIME=$((TIME * 3600))
#check if time is an int or throw error 
echo running for $TIME hours
#run sauron
#run sentry
./sentry.sh
./sauron.sh
#run start script 
./wakessh.sh 


#sleep for number of hours 
sleep $"SLEEP_TIME"
#run end script 
#todo turn this into a method and send results to .log file
./sleepssh.sh
ps -ef | grep sentry.sh | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep sauron.sh | grep -v grep | awk '{print $2}' | xargs kill
exit
