#!/bin/bash
HOST=$1
shift
for ARG in "$@"
do
        sudo nmap -Pn --max-retries 0 -p $ARG $HOST
done

##    ./knock.sh 192.168.255.1 8881 7777 9991 
