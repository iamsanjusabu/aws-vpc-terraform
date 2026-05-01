#!/bin/bash

# RUN THIS WHILE INSIDE TMUX
# MUST BE INSIDE THE "applications" FOLDER TO RUN

set -e

sudo apt update
sudo apt install openjdk-25-jdk -y

java -jar spring-boot/spring-boot-api.jar

# "CTRL + B" AND "D" TO EXIT TMUX