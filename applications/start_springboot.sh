#!/bin/bash

# RUN THIS WHILE INSIDE TMUX

sudo apt install openjdk-25-jdk -y

java -jar spring-boot/spring-boot-api.jar

# "CTRL + B" AND "D" TO EXIT TMUX