#!/bin/bash

/usr/bin/apt update -y
/usr/bin/apt upgrade -y
/usr/bin/apt install -y python3
/usr/bin/apt install -y git
/usr/bin/apt install -y nginx
/usr/sbin/systemctl start nginx
/usr/sbin/systemctl enable nginx
