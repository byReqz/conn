#!/bin/bash

while [ ! -n "$1" ]; do
      echo "Usage: $0 (options) <ip>"
      echo "Options:"
      echo " -m/--multi -- test multiple ips / disable portscan"
      echo " -h/--help -- show help"
      echo " -6/--force-ipv6 -- force ipv6 portscanning (also forces portscanning)"
      echo " -4/--force-ipv4 -- force ipv4 portscanning (also forces portscanning)"
      echo " -y/--yes -- portscan without asking"
      echo " -n/--no -- dont portscan"
      echo " -p/--portscan -- same as -y"
      echo " -w/--wait -- wait for active connection"
      exit
done
while [ ! -z "$1" ]; do
   if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]];then
      echo "Usage: $0 (options) <ip> (y/n)"
      echo "Options:"
      echo " -m/--multi -- test multiple ips / disable portscan"
      echo " -h/--help -- show help"
      echo " -6/--force-ipv6 -- force ipv6 portscanning (also forces portscanning)"
      echo " -4/--force-ipv4 -- force ipv4 portscanning (also forces portscanning)"
      echo " -y/--yes -- portscan without asking"
      echo " -n/--no -- dont portscan"
      echo " -p/--portscan -- same as -y"
      echo " -w/--wait -- wait for active connection"
      exit
   elif [[ $1 == "-m" ]] || [[ "$1" == "--multi" ]];then
      echo "multi-ip mode, portscan disabled"
      echo "-------------------Availability----------------------"
      fping -e $@
      echo "-----------------------------------------------------"
      exit
   elif [[ $1 == "-y" ]] || [[ $1 == "-p" ]] || [[ "$1" == "--portscan" ]] || [[ "$1" == "--yes" ]];then
      echo "checking connection status for $2"
      echo "-------------------Availability----------------------"
      fping -e $2
      echo "-----------------------------------------------------"
      echo "-------------------Portscan---------------------"
      nmap --reason -Pn $2
      fping -c 4 -A $2
      echo "------------------------------------------------"
      exit
   elif [[ $1 == "-n" ]] || [[ "$1" == "--no" ]];then
      echo "checking connection status for $2"
      echo "-------------------Availability----------------------"
      fping -e $2
      echo "-----------------------------------------------------"
      exit
   elif [[ $1 == "-6" ]] || [[ "$1" == "--force-ipv6" ]];then
      echo "-6 used, forcing IPv6 portscanning"
      echo "checking connection status for $2"
      echo "-------------------Availability----------------------"
      fping -6 -e $2
      echo "-----------------------------------------------------"
      echo "-------------------Portscan---------------------"
      nmap --reason -Pn -6 $2
      fping -6 -c 4 -A $2
      echo "------------------------------------------------"
      exit
   elif [[ $1 == "-4" ]] || [[ "$1" == "--force-ipv4" ]];then
      echo "-4 used, forcing IPv4 portscanning"
      echo "checking connection status for $2"
      echo "-------------------Availability----------------------"
      fping -4 -e $2
      echo "-----------------------------------------------------"
      echo "-------------------Portscan---------------------"
      nmap --reason -Pn $2
      fping -6 -c 4 -A $2
      echo "------------------------------------------------"
      exit
   elif [[ "$1" == "-w" ]] || [[ "$1" == "--wait" ]];then
      echo "-w used, waiting for active connection"
      echo "checking connection status for $2"
      while [[ "$(fping -m -q -u $2)" == "$2" ]]; do :
         done
      notify-send "$2 is now reachable" -u normal -t 8000 -a conn
      echo "-------------------Availability----------------------"
      fping -e $2
      echo "-----------------------------------------------------"
      echo "portscan? (y/n) (default: y)"
         read portscan
         if [[ "$portscan" = "y" ]] || [[ -z "$portscan" ]]; then
            echo "-------------------Portscan---------------------"
            nmap --reason -Pn $2
            fping -c 4 -A $2
            echo "------------------------------------------------"
            exit
         else
            exit
         fi
      exit
   elif [[ ! "$1" =~ [0-9]{1,3}(\.[0-9]{1,3}){3} ]] && [[ "$1" =~ [:] ]] && [[ ! "$2" =~ [:] ]] && [[ -z "$3" ]];then
      echo "detected IPv6 adress -> using -6"
      echo "checking connection status for $1"
      echo "-------------------Availability----------------------"
      fping -6 -e $1
      echo "-----------------------------------------------------"
      echo "portscan? (y/n) (default: y)"
         read portscan
         if [[ "$portscan" = "y" ]] || [[ -z "$portscan" ]]; then
            echo "-------------------Portscan---------------------"
            nmap --reason -Pn -6 $1
            fping -6 -c 4 -A $1
            echo "------------------------------------------------"
         else
            exit
         fi
      exit
   elif [[ "$1" =~ [0-9]{1,3}(\.[0-9]{1,3}){3} ]] && [[ "$2" =~ [0-9]{1,3}(\.[0-9]{1,3}){3} ]] || [[ "$3" =~ [0-9]{1,3}(\.[0-9]{1,3}){3} ]] && [[ ! "$1" =~ [-] ]];then
      echo "multi-ip input detected, portscan disabled"
      echo "-------------------Availability----------------------"
      fping -e $@
      echo "-----------------------------------------------------"
      exit
   elif [[ ! "$1" =~ [0-9]{1,3}(\.[0-9]{1,3}){3} ]] && [[ ! "$2" =~ [0-9]{1,3}(\.[0-9]{1,3}){3} ]] && [[ "$1" =~ [:] ]] && [[ "$2" =~ [:] ]] || [[ ! "$3" =~ [0-9]{1,3}(\.[0-9]{1,3}){3} ]] && [[ ! "$1" =~ [-] ]] && [[ ! "$1" =~ [0-9]{1,3}(\.[0-9]{1,3}){3} ]] && [[ ! "$2" =~ [0-9]{1,3}(\.[0-9]{1,3}){3} ]] && [[ "$1" =~ [:] ]] && [[ "$2" =~ [:] ]];then
      echo "multi-ipv6 input detected, portscan disabled"
      echo "-------------------Availability----------------------"
      fping -e -6 $@
      echo "-----------------------------------------------------"
      exit
   else
      echo "checking connection status for $1"
      echo "-------------------Availability----------------------"
      fping -e $1
      echo "-----------------------------------------------------"
      echo "portscan? (y/n) (default: y)"
         read portscan
         if [[ "$portscan" = "y" ]] || [[ -z "$portscan" ]]; then
            echo "-------------------Portscan---------------------"
            nmap --reason -Pn $1
            fping -c 4 -A $1
            echo "------------------------------------------------"
            exit
         else
            exit
         fi
fi
done
