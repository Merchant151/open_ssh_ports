  sudo ufw enable
  sudo ufw allow from 192.168.1.0/24 to any port 443
  sudo ufw allow from 192.168.1.0/24 to any port 22
  sudo systemctl start ssh
  sudo ufw status verbose
  sudo systemctl status ssh
