#stoping and reseting firewall
sudo systemctl stop ssh
sudo systemctl disable ssh
#sudo ufw reset
sudo ufw delete allow from 192.168.1.0/24 to any port 443 
sudo ufw delete allow from 192.168.1.0/24 to any port 22 
sudo systemctl stop fail2ban
#status and info
sudo systemctl status ssh
sudo ufw status verbose
ps aux | grep ssh|grep -v 'grep ssh' 

