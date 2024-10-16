#stoping and reseting firewall
sudo systemctl stop ssh
sudo systemctl disable ssh
#instead of reseting ufw I should just remove my rules! 
sudo ufw reset

#status and info
sudo systemctl status ssh
sudo ufw status verbose
ps aux | grep ssh 

