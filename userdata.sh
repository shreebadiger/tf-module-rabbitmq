#!/bin/bash


ansible-pull -i localhost, -U https://github.com/shreebadiger/roboshop-ansible roboshop.yml -e role_name=rabbitmq -e env=${env} | tee -a /opt/userdata.log
 