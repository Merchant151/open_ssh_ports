# Some ip/ssh notes: 

These are the notes I while building the scripts. The information in here is very loosely organized as a cheatsheet of commands that will help
set up a ssh sever and connection and manage tools such as ufw and fail2ban. perhaps I will re-organize these if I end up coming back to this page often.

use:  
```bash
 ip address show

```
or 
```
ip a 
```

This will show your local network address. What I am typically looking for is a local ip address assuming I am connecting ssh over a local network. For example if I am going to use the old IPv4 And I am connected via my standard lan connection I can run: 

```bash
ip a | grep eno1
```
```bash
#output
inet 192.168.1.10/24 brd 192.168.1.255 scope global eno1
```
Alternitive output: 
```
wlan0 Link encap:Ethernet HWaddr 70:f1:a1:c2:f2:e9
inet addr:92.168.1.10 Bcast:192.168.1.255 Mask:255.255.255.0
inet6 addr: fe80::73f1:a1ef:fec2:f2e8/64 Scope:Link
```
You determine the ip range from the the mask. For example 255.255.255.0 and 192.168.1.10/24 from the same ip and show the range to be from 192.168.1.0 to 192.168.1.255. 

Scan your network with: 

```bash 
nmap -sn 192.168.1.0/24
```
Example output: 
```bash
Starting Nmap 7.92 ( https://nmap.org ) at 2024-09-14 10:00 UTC
Nmap scan report for 192.168.1.1
Host is up (0.0050s latency).
Nmap scan report for 192.168.1.10
Host is up (0.010s latency).
Nmap scan report for 192.168.1.20
Host is up (0.020s latency).
Nmap scan report for 192.168.1.30
Host is up (0.015s latency).
Nmap scan report for 192.168.1.255
Host is up (0.012s latency).
Nmap done: 256 IP addresses (5 hosts up) scanned in 3.00 seconds
```
# A word about SSH safety... 

It's important not to leave ports open and to finely control and monitor network access when doing stuff like this on a computer that is connected to the internet. 
For the purposes of this project. I will only be opening SSH to myself over my local network. I will try to follow the following practices: 

[X] I will use firewall deny rules to prevent un-Authorized connection.

[ ] I will monitor all active connections from the host. 

[X] I will consider using SSH keys instead of password connection. 

### Steps 

Lets enable port 22 on a Debian based system. 
For this we will use ufw (Uncomplicated Firewall)

First verify ufw is enabled. by default ufw allows all outgoing traffic and deny's all incoming traffic. 

```bash
$> sudo ufw status
Status: inactive
```
If inactive enable with:

```bash
$> sudo ufw enable
$> sudo ufw status
Status: active
```

Note ufw by default deny's all traffic. Lets allow only the traffic from the network above. 192.168.1.0/24 Specifically the subnet
However a smaller range can be used or specific IP if wanted. As least priviledge is probably best!  

```bash
$> sudo ufw allow from 192.168.1.0/24 to any port 22
#i allow tcp for scan requests from smap so I can pick up the ip address  
$> sudo ufw allow from 192.168.1.0/24 to any port 443

#to verify current firewall rules use
$> sudo ufw status verbose

#if you want to reset your firewall rules to default use
$> sudo ufw reset
```
## Configuring SSHD on the remote 

To enable ssh to use ssh keys we will likely need to enable that form of authentication. 

sshd is configured in: 
```bash
/etc/ssh/sshd_config
```
modify the file and add the following lines: 
```
LogLevel DEBUG

PermitRootLogin no

PasswordAuthentication no
PubkeyAuthentication yes

```

Aditionall Notes: 

Auth attempts will be logged in /var/log/auth.log and if in debug mode we will likely be able to see the 
auth rules printed here 

## Activating SSH 
most linux systems are using Systemd which means we will use systemctl command to start ssh 

On the server use: 
```bash
$> sudo systemctl enable ssh
$> sudo systemctl start ssh
# verify ssh status 
$> sudo systemctl status ssh
```
#### Warning remember not to leave SSH enabled unless you know what you are doing!

Monitoring and logging Connection 

I am going to try to use a tool called fail2ban to monitor and track all authentication attempts
I will also use a combination of w who and last to monitor log and track system activity while SSH is enabled! 
## Configure fail2ban 

Install fail to ban 

Debian: 
```bash
$> sudo apt install fail2ban
```
Then copy the conf files to a local files. This will isnure orriginal configuration file is not modified on update. The jail file is where ssh and ban rules are configured whil fail2ban is for general configurations.
```bash
$> cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
$> cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```
Now we are going to set agressive ban rules and activate sshd in fail2ban.
As well as perminatly ban any bad actors! 



edit the jail.local file and under the [sshd] secition add enabled = true

```vim
[sshd]

enabled = true
mode = aggressive
```
Also add adjust fail ban and find times using a negative bantime will permit permanent bans

under the default tag modify the following options 
```vim
# this will assist in error handling
backend = systemd

# "bantime" is the number of seconds that a host is banned.
bantime  = -1

# A host is banned if it has generated "maxretry" during the last "findtime"
# seconds.
findtime = 600
maxretry = 3
```

set ban action to ufw since we are using ufw firewall.

```bash
banaction = ufw
```

## fail2ban client 

```bash
$> fail2ban-client status
```
use the fail to ban client to check status and unban ips. 

When you are ready to start fail2ban use 

```bash
fail2ban-client start
```
Lets say you try to login... and do something wrong... and you need to unban yourself use the following command

```bash
$> sudo fail2ban-client set sshd unbanip 192.168.1.<IP> 
```

## creating ssh keys

ssh keys are a more secure way to connect than a password auth. The way it works is we generate 'keys' one public and one private as an asymetric key-pair. The Public Key is used to encrypt messages and the private key is used to decrypt messages.
The way the host authenticates the client is by sending a random 'question' encrypted by the public key and the user has to send back the 'answer' which they can only derive by decrypting it first with the private key. what makes it secure is that the private key is never shared and only exists in a secure sometimes encrypted file on the clients computer. The key can only be comprimised if it shared or the clients machine is compromised. it is best practice to use a secure encryption algorythem when generating the keys and to regularly rotate keys over time. 

To create a ssh key we can use OpenSSH's keygen command. 
```bash
$> ssh-keygen -t rsa -b 4096 
```
it will ask you where you want to store it and what password you would like to use. 

SSH keys are ususally stored in a /home/user/.ssh/key_name file 

A password will encrypt your private key. 

You can specify the file name in an option like so:  
```bash
$> ssh-keygen -t rsa -b 4096 -f /home/{user}/.ssh/{key_name}
```

### On the remote machine add the public key to the authorized_keys file 
And change the permissions on the file.

```bash
$> cat ~/{keys} >> ~/.ssh/authorized_keys
$> chmod 600 ~/.ssh/authorized_keys
```

## connecting via remote

## When you are done with SSH always deativate and disable it with 

```bash
$> sudo systemctl stop ssh
$> sudo systemctl disable ssh
# verify ssh status 
$> sudo systemctl status ssh
```

## any other security considerations. 
One thing I noticed is when you disable ssh and reset the firewall this doesn't inturrupt any active connections. 
So to monitor active connections you can check with 
```bash
$> ps aux | grep ssh
```
output should give you the psid of any active ssh feel free to kill it if you want to force any active connections to exit from the remote. (otherwise if you are the client just exit from client)
```bash
$> kill 11223
```
some places reccomend kill with option -u but this will kill all processes by that user and my ssh user and primary user are the same so I avoid this! but if you have separate users and want to kill all processes started by the client 
feel free to use it. 

## create automated live log following 

## destroy outdated logs to manage storage usage. 


