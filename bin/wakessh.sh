sudo ufw enable
sudo ufw allow from 192.168.1.0/24 to any port 443
sudo ufw allow from 192.168.1.0/24 to any port 22
sudo systemctl start ssh
sudo ufw status verbose
sudo systemctl status ssh
# greping out ipv4 addresses in ip (not currently sure how to grab my specific network consistently)  
ip a |grep inet|grep -v inet6
