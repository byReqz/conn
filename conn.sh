#! /bin/bash
if [[ -z "$1" ]]; then
    echo "Usage: conn [ip] (y/n)"
    exit
elif [[ "$2" != p ]]; then
    echo "multi-ip mode detected, only checking availability"
    echo ""
    echo "-------------------Availability----------------------"
    fping "$@"
    echo "-----------------------------------------------------"
    exit
elif [[ -n "$1" ]]; then
    echo "checking connection status for $1"
    echo "-------------------Availability----------------------"
    fping $1
    echo "-----------------------------------------------------"
fi
if [[ -z "$2" ]]; then
       echo "portscan? (y/n)"
       read portscan
       if [[ "$portscan" = "y" ]]; then
       echo "-------------------Portscan---------------------"
       nmap -Pn $1
       fping -c 4 -A $1
       echo "------------------------------------------------"
       exit
       elif [[ "$portscan" = "n" ]]; then
       exit
       fi
elif [[ "$2" = "y" ]]; then
       echo "-------------------Portscan---------------------"
       nmap -Pn $1
       fping -c 4 -A $1
       echo "------------------------------------------------"
       exit
elif [[ "$2" = "n" ]]; then
       exit
fi
