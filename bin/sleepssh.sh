#stoping and reseting firewall
sudo systemctl stop ssh
sudo systemctl disable ssh
#instead of reseting ufw I should just remove my rules! 
sudo ufw reset
sudo systemctl stop fail2ban
#status and info
sudo systemctl status ssh
sudo ufw status verbose
ps aux | grep ssh|grep -v 'grep ssh' 
