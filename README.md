# open_ssh_ports
Temporary open ssh and print open IP with Dynamic DHCP

Goal of this project have a shell script that opens and closes ssh ports when running. 


# 🚧 This is my README.md this is a work in progress! 🦺 🏗️


<div align="center">
    <a href="https://en.wikipedia.org/wiki/HTTP_404">Home Page</a> |
    <a href="https://en.wikipedia.org/wiki/HTTP_404/">About the project</a> |
    <a href="https://en.wikipedia.org/wiki/HTTP_404">Screenshots</a> |
    <a href="https://en.wikipedia.org/wiki/HTTP_404">Documentation</a> |
    <a href="https://en.wikipedia.org/wiki/HTTP_404">About the Developer</a> |
    <a href="https://en.wikipedia.org/wiki/HTTP_404">License</a>
</div>


Sections to build 

## Section
badges -sub section
## What is this project?
Open SSH Ports is a set of bash scripts designed to help me quickly operate a secure connection between a host and client.

In my case I am connecting between my desktop and laptop.

So, what do the scripts *do*? They open port 22 and 443 for a specified amount of time. manage the firewall and start extra security measures to ban unauthorized connections. 
Along with the script. Additionally the scripts monitor ssh while off and insure ssh server is not running while the scripts are not in use. The scripts aggrigate logs within the project logs directory to easily audit SSH activity. 

I am using cron jobs to monitor the ports I will share along with the setup of the project. 

### Overview

This repro comes with 5 shell scripts all of wich are used for the project. The repro also contains a bin and log directory which need to remain intact for the scripts to run properly. The dependencies that are needed are not included but I will list them.
Dependenies:
ufw - A firewall that can be easily replaced by modifying the scripts to exchange a prefered firewall. ufw typically comes default on deb based systems. 
Fail2Ban - A tool that will ban unauthorized ips that attempt to connect. 
systemctl,systemd,ssh/sshd - These dependencies should be a given but I will list them anyway.

#### Scripts: 

- myssh - A script that needs to be run with elivated privleges will run the entire project for a specified amount of time in hours
- sauron - This script takes system logs from the system firewall authenticator and fail2ban and puts them in the repo log directory. With this log you can audit all ssh related activity.
- sentry - This script insures SSH/SSHD is not running unless myssh is active. This script can stop the SSH/SSHD service on its own and requires elivated privleges.  
- sleepssh - The 'sleep' process cancels all firewall rules closes ports and stops the ssh service.    
- wakessh - The 'wake' process creates firewall rules opens ports and starts the serivce. Wake and sleep scripts will need to be configured depending on you connection requirements.

### Setup

For the project to operate as intended I use a few cronjobs to run the project.
#### Cronjobs: 
on the root crontab (for elivated privleges)
5 */1 * * * {projectLocation}/open_ssh_ports/bin/sentry.sh -c >> {projectLocation}/open_ssh_ports/logs/cron.log 2>&1
- This will run every hour running sentry in cron mode. which checks if an instance of myssh is running and checks if a ssh server is running.
- note: pick any interval that works for you.
on user crontab
8 * * * *  grep "Critical" {projectLocation}/open_ssh_ports/logs/sentry.log && grep "Critical" {projectLocation}/open_ssh_ports/logs/sentry.log >> ~/Desktop/CRITICAL_ALERT.log
  - usefull for gui desktop this will create an error file if ssh was ever left on. similar methods can be used to alert for all connections by greping the auth.log from the sauron.log file.


### Notes
I took notes on the softwares used in this project and the process of setting up and using SSH along with this project. 

## About the Author 
Hi, I am Mart Miller. I make small projects to expand my skill set. I am currently interested in learning how to automate and script processes in Shell and Python. 



You can find those notes [here!](https://github.com/Merchant151/open_ssh_ports/blob/master/notes.md)
## Lincense 
Licensed under the MIT License, Copyright (c) 2025 Merchant151
