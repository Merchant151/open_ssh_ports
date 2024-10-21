#My goal for this script is to create a standalone logger  that while running will send data to a local log and will also tail that log

#There are multiple logs I would like to follow from the var/log 
#/var/log/fail2ban
#/var/log/auth.log
#/var/log/ufw.log

#I will likely need to use a while loop on a read command to only update when changes happen and then tail the file with those changes

