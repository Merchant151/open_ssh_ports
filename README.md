# open_ssh_ports
[![badge1](https://img.shields.io/badge/OS-Linux-green)](#)
[![badge2](https://img.shields.io/badge/Language-Bash-green)](#)
[![badge3](https://img.shields.io/badge/License-MIT-green)](#)

Temporary open ssh and print open IP with Dynamic DHCP

Goal of this project have a shell script that opens and closes ssh ports when running. Allowing the user to Open monitor and easily control an ssh host on a network for security purposes.

<div align="center">
    <a href="https://github.com/Merchant151/open_ssh_ports/blob/master/README.md#what-is-this-project">About this project</a> |
    <a href="https://github.com/Merchant151/open_ssh_ports/blob/master/README.md#Overview">Project overview</a> |
    <a href="https://github.com/Merchant151/open_ssh_ports/blob/master/README.md#scripts">Scripts</a> |
    <a href="https://github.com/Merchant151/open_ssh_ports/blob/master/README.md#setup">Setup</a> |
    <a href="https://github.com/Merchant151/open_ssh_ports/blob/master/README.md#About-the-Developer">About the Developer</a> |
    <a href="https://github.com/Merchant151/open_ssh_ports/blob/master/README.md#License">License</a>
</div>


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
```
5 */1 * * * {projectLocation}/open_ssh_ports/bin/sentry.sh -c >> {projectLocation}/open_ssh_ports/logs/cron.log 2>&1
```
- This will run every hour running sentry in cron mode. which checks if an instance of myssh is running and checks if a ssh server is running.
- note: pick any interval that works for you.
<br> on user crontab
```
8 * * * *  grep "Critical" {projectLocation}/open_ssh_ports/logs/sentry.log && grep "Critical" {projectLocation}/open_ssh_ports/logs/sentry.log >> ~/Desktop/CRITICAL_ALERT.log
```
  - useful for gui desktop this will create an error file if ssh was ever left on. similar methods can be used to alert for all connections by greping the auth.log from the sauron.log file.

<br>For setup you additionally need to have ufw or (change the firewall used by the software) And you will need to install and configure fail2ban. I beileve there are some notes down below to help with that. 

### Notes
I took notes on the softwares used in this project and the process of setting up and using SSH along with this project. 

You can find those notes [here!](https://github.com/Merchant151/open_ssh_ports/blob/master/notes.md)

## About the Developer 
Hi, I am Mart Miller. I make small projects to expand my skill set. I am currently interested in learning how to automate and script processes in Shell and Python. 

## License 
Licensed under the MIT License, Copyright (c) 2025 Merchant151
