#My goal for this script is to create a standalone logger  that while running will send data to a local log and will also tail that log

#There are multiple logs I would like to follow from the var/log 
echo -n '<fail log>'
tail -1 /var/log/fail2ban
echo -n '<auth log>' && tail -1 /var/log/auth.log
echo -n '<ufw log>' && tail -1 /var/log/ufw.log

#I will likely need to use a while loop on a read command to only update when changes happen and then tail the file with those changes

