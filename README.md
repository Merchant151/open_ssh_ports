## open_ssh_ports
Temporary open ssh and print open IP with Dynamic DHCP

Goal of this project have a shell script that opens and closes ssh ports when running. 







### Some ip/ssh notes: 

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

[ ] I will use firewall deny rules to prevent un-Authorized connection.

[ ] I will monitor all active connections from the host. 

[ ] I will consider using SSH keys instead of password connection. 

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
```

Activating SSH 
most linux systems are using Systemd which means we will use systemctl command to start ssh 

On the server use: 
```bash
$> sudo systemctl enable ssh
$> sudo systemctl start ssh
```
#### Warning remember not to leave SSH enabled unless you know what you are doing!

Monitoring and logging Connection 

I am going to try to use a tool called fail2ban to monitor and track all authentication attempts
I will also use a combination of w who and last to monitor log and track system activity while SSH is enabled! 
## Configure fail2ban 

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

```bash
$> cat ~/{keys} >> ~/.ssh/authorized_keys
```

# connecting via remote

# When you are done with SSH always deativate and disable it with 

```bash
$> sudo systemctl stop ssh
$> sudo systemctl disable ssh
```

# any other security considerations. 

# create automated live log following 

# destroy outdated logs to manage storage usage. 


