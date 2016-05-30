#!/bin/bash

source ~/.bashrc
pm2 start /www/app.js
/usr/sbin/sshd -D