## open_ssh_ports
Temporary open ssh and print open IP with Dynamic DHCP

Goal of this project have a shell script that opens and closes ssh ports when running. 







Some ip/ssh notes: 

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

For the purposes of this project. I will only be opening SSH to myself over my local network. 
I will use firewall deny rules to prevent un-Authorized connection
I will monitor all active connections from the host. 
I will consider using SSH keys instead of password connection. 

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
Warning remember not to leave SSH enabled unless you know what you are doing!

Monitoring Connection 

creating ssh keys

connecting via remote

Shutting down SSH and invoking Deny all rule

any other security considerations. 




