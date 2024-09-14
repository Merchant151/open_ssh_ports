# open_ssh_ports
Temporary open ssh and print open IP with Dynamic DHCP

Goal of this project have a shell script that opens and closes ssh ports when running. 







Some ip notes: 

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
