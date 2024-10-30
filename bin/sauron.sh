#!/bin/bash
#My goal for this script is to create a standalone logger  that while running will send data to a local log and will also tail that log

murderProcesses(){
   echo "ending bg process" 
   kill -9 $PID1 $PID2 $PID3
   #add 2>/dev/null if want to suppress output here
   echo -n '<Sauron LOG> ' >> ../logs/sauron.log 
   LOG_TIME=DATE
   echo -n '$LOG_TIME ' >> ../logs/sauron.log
   echo ': I am being murdered! killing processes' >> ../logs/sauron.log
   exit
}

trap murderProcesses SIGINT SIGTERM

#There are multiple logs I would like to follow from the var/log 
echo -n '<fail log>'
tail -1 /var/log/fail2ban.log
echo -n '<auth log>' && tail -1 /var/log/auth.log
echo -n '<ufw log>' && tail -1 /var/log/ufw.log

#I will likely need to use a while loop on a read command to only update when changes happen and then tail the file with those changes

tail -vf /var/log/fail2ban.log | awk 'BEGIN{p="fail2ban.log"} {print p,$0}' >> ../logs/sauron.log &
PID1=$!
tail -vf /var/log/auth.log | awk 'BEGIN{p="auth.log"} {print p,$0}' >> ../logs/sauron.log &
PID2=$!
tail -vf /var/log/ufw.log | awk 'BEGIN{p="ufw.log"} {print p,$0}' >> ../logs/sauron.log & 
PID3=$!

wait
