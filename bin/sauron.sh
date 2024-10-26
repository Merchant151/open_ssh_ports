#!/bin/bash
#My goal for this script is to create a standalone logger  that while running will send data to a local log and will also tail that log

#There are multiple logs I would like to follow from the var/log 
echo -n '<fail log>'
tail -1 /var/log/fail2ban.log
echo -n '<auth log>' && tail -1 /var/log/auth.log
echo -n '<ufw log>' && tail -1 /var/log/ufw.log

#I will likely need to use a while loop on a read command to only update when changes happen and then tail the file with those changes

tail -vf /var/log/fail2ban.log | awk 'BEGIN{p="fail2ban.log"} {print p,$0}' >> ../logs/sauron.log &
tail -vf /var/log/auth.log | awk 'BEGIN{p="auth.log"} {print p,$0}' >> ../logs/sauron.log &
tail -vf /var/log/ufw.log | awk 'BEGIN{p="ufw.log"} {print p,$0}' >> ../logs/sauron.log & 

sleep 120
