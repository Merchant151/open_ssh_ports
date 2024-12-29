#stoping and reseting firewall
D=$(date)
LOGFILE=$(dirname "$0")/../logs/sleepssh.log
echo "sleepssh was activated at $D"
systemctl stop ssh
echo "RESULT OF STOP SSH is $?" >> $LOGFILE
systemctl disable ssh >> $LOGFILE
echo "RESULT OF DISABLE SSH is $?" >> $LOGFILE
#sudo ufw reset
ufw delete allow from 192.168.1.0/24 to any port 443
echo "RESULT OF UFW DELETE ALLOW to 443 is $?" >> $LOGFILE
ufw delete allow from 192.168.1.0/24 to any port 22 
echo "RESULT OF UFW DELETE ALLOW to 22 is $?" >> $LOGFILE
systemctl stop fail2ban
#status and info
systemctl status ssh >> $LOGFILE
ufw status verbose >> $LOGFILE
ps aux | grep ssh|grep -v 'grep ssh' 
D=$(date)
echo "sleepssh completed run at $D" >> $LOGFILE
echo "=============================================" >> $LOGFILE
