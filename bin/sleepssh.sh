#stoping and reseting firewall
systemctl stop ssh
systemctl disable ssh
#sudo ufw reset
ufw delete allow from 192.168.1.0/24 to any port 443 
ufw delete allow from 192.168.1.0/24 to any port 22 
systemctl stop fail2ban
#status and info
systemctl status ssh
ufw status verbose
ps aux | grep ssh|grep -v 'grep ssh' 

