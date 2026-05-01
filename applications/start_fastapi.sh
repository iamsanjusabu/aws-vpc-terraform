#!/bin/bash

# RUN THIS WHILE INSIDE TMUX

set -e

sudo apt install python3-venv -y

python3 -m venv python_venv

source python_venv/bin/activate

pip install fastapi[standard]

fastapi dev fastapi/main.py

# "CTRL + B" AND "D" TO EXIT TMUX