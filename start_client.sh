#!/usr/bin/env bash
# Automation script
HOST=$1
PORT=$2

if [ -z ${HOST} ]; then
  echo "No argument supplied"
  echo $"Usage: first argument must be the host of the backend (local or public IPv4)"
  exit 1
fi

if [ -z ${PORT} ]; then
  echo "No argument supplied"
  echo $"Usage: first argument must be the port"
  exit 1
fi

function installation_of_prerequisites() {
    apt update && apt install -y python3
    pip3 install -r requirements.txt
}

function print(){
    BACKGROUND_COLOR="\033[31;42m"
    NO_COLOR="\033[0m"
	echo -e ${BACKGROUND_COLOR} $1 ${NO_COLOR}
}

print "Start ..."
print "1 - Install the prerequisite packages"
installation_of_prerequisites

print "Launch the client ${HOST}:${PORT}"
python3 -m client --host ${HOST} --port ${PORT}