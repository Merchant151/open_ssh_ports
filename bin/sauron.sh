#!/bin/bash
#My goal for this script is to create a standalone logger  that while running will send data to a local log and will also tail that log
LOGDIR=$(dirname "$0")/../logs
sleep 5s 
echo '<sauron> starting sauron logger'
#adding basic option handling
while getopts ":h" option; do 
	case $option in 
		h) 
			echo 'help option'
			echo 'There are no options becides help'
			echo 'the purpose of this script is to log ssh activity it is automatically started and killed by myssh.sh'
			exit;;
		esac
	done
#if [ $OPTIND -eq 1 ]; then echo "No options passed" && exit; fi
murderProcesses(){
   echo "<Sauron> ending bg process" 
   kill $PID1 $PID2 $PID3
   #add 2>/dev/null if want to suppress output here
   echo -n '<Sauron LOG> ' >> $LOGDIR/sauron.log 
   LOG_TIME=$(date)
   echo -n "$LOG_TIME " >> $LOGDIR/sauron.log
   echo ': I am being murdered! killing processes' >> $LOGDIR/sauron.log
   exit
}

trap murderProcesses SIGINT SIGTERM

#There are multiple logs I would like to follow from the var/log 
echo -n '<fail log>' && tail -1 /var/log/fail2ban.log
echo ''
echo -n '<auth log>' && tail -1 /var/log/auth.log
echo ''
echo -n '<ufw log>' && tail -1 /var/log/ufw.log
echo ''

#I will likely need to use a while loop on a read command to only update when changes happen and then tail the file with those changes

tail -vf /var/log/fail2ban.log | awk 'BEGIN{p="fail2ban.log"} {print p,$0}' >> $LOGDIR/sauron.log &
PID1=$!
tail -vf /var/log/auth.log | awk 'BEGIN{p="auth.log"} {print p,$0}' >> $LOGDIR/sauron.log &
PID2=$!
tail -vf /var/log/ufw.log | awk 'BEGIN{p="ufw.log"} {print p,$0}' >> $LOGDIR/sauron.log & 
PID3=$!

#wait

while true 
do
echo -n `date` >> $LOGDIR/sauron.log 
echo ' sauron is still running.' >> $LOGDIR/sauron.log
sleep 2m
done

