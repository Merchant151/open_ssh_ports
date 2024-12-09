echo '<WAKESSH> Starting in 11s'
sleep 11s
echo '==============================================================='
echo '<WAKESSH> WAKING AND OPENING PORTS NOW, See you, space cowboy'
echo '==============================================================='
ufw enable
ufw allow from 192.168.1.0/24 to any port 443
ufw allow from 192.168.1.0/24 to any port 22
systemctl start ssh
ufw status verbose
systemctl status ssh
systemctl start fail2ban
# greping out ipv4 addresses in ip (not currently sure how to grab my specific network consistently)  
ip a |grep inet|grep -v inet6
