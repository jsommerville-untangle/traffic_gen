# pytraffic

Dockerized Python Web Traffic Generator For Untangle NGFW and MFW products

# Recommended Setup

Recommend configuring device with 3 NIC's, one for local network (ssh access), one to connect to NGFW, and one to connect to MFW

NOTE: if using Ubuntu 20 you will have to edit /etc/netplan/ configuration, example config shown on netplan-example.yaml file

# Make directory for logs on host

On the host device, make a directory called traffic_logging, this will be used for the logs from the containers:

ex:

- mkdir -p ~/traffic_logging/ngfw

- mkdir -p ~/traffic_logging/mfw

# Pull Docker Image

- docker pull container-registry.untangle.com/traffic_gen:latest

# Edit .env file

Edit the .env file in the repo to match the name of the interfaces on your device and the logging directories

# Create traffic logging, ngfw-traffic, and mfw-traffic commands

This will create a copy of the commands listed below to /usr/local/bin and make them executable so they can run as commands on the host. These commands assume that your repo is in /home, i.e ~/traffic_gen and your logging is in ~/traffic_logging, if not you will need to edit these files and change the repo path and logging path in those commands.

The following commands need to be run from the repo directory:

- sudo chmod +x commands.sh

- sudo ./commands.sh

If you need to edit:

- sudo nano /usr/local/bin/mfw-traffic

- sudo nano /usr/local/bin/ngfw-traffic

- sudo nano /usr/local/bin/mfw-logs

- sudo nano /usr/local/bin/mfw-log-backup

- sudo nano /usr/local/bin/ngfw-logs

- sudo nano /usr/local/bin/ngfw-log-backup

# Usage

These command require 3 parameters, number of clients, time (in minutes), and a name for the backup folder. These commands also run the *-log-backup command at the end:

- ngfw-traffic 10 30 test_folder

- mfw-traffic 10 30 test_folder

These command will ask for name to create a folder, aggregate the logs, show stats, create a summary, and backup the logs in that folder. If you cancelled your ngfw/mfw-traffic commands and need to aggregate your logs, use these commands:

- ngfw-log-backup

- mfw-log-backup

These commands will aggregate the logs, show stats, but will not create summary or backups, for use while ngfw/mfw-traffic commands are running for real time updates

- ngfw-logs

- mfw-logs

# To run containers manually

Replace X with number of clients you want to run. If needed change the directory to match your repo.

- docker-compose -f ~/traffic_gen/mfw.yml up --scale mfw-traffic=X

- docker-compose -f ~/traffic_gen/ngfw.yml up --scale ngfw-traffic=X

# To stop containers that are running daemonized

- docker-compose -f ~/traffic_gen/mfw.yml down

- docker-compose -f ~/traffic_gen/ngfw.yml down

# mfw-sessions commands

These commands are to be run on mfw itself. 

This command will collect date, load averages, and active sessions every 1 minute. Prints information to files sessions_count.log and sessions_count_dates.log

- mfw-sessions.sh 

This command will parse logs created by mfw-sessions.sh, creates a report .summary file with that information and prints to screen. requires parameter for file name

- mfw-sessions-avg.sh test_file