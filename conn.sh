#!/bin/bash

if [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/conn.sh | md5sum | cut -c -32) != $(md5sum $0 | cut -c -32) ]] && [[ -z $1 ]] || [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/conn.sh | md5sum | cut -c -32) != $(md5sum $0 | cut -c -32) ]] && [[ $1 != "--update" ]] || [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/conn.sh | md5sum | cut -c -32) != $(md5sum $0 | cut -c -32) ]] && [[ $1 != "-u" ]];then
  echo "#############################################"
  echo -e "\e[4mnote: newer version detected, use -u to update\e[0m"
  echo "#############################################"
  echo ""
fi
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
         echo " -u/--update -- update the script to the newest version"
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
         echo " -u/--update -- update the script to the newest version"
         exit
      elif [[ $1 == "-m" ]] || [[ "$1" == "--multi" ]];then
         echo "multi-ip mode, portscan disabled"
         echo "-------------------Availability----------------------"
         fping -e $@
         echo "-----------------------------------------------------"
         exit
      elif [[ $1 == "-y" ]] || [[ $1 == "-p" ]] || [[ "$1" == "--portscan" ]] || [[ "$1" == "--yes" ]];then
         echo "checking connection status for $2"
          if [[ -n $(nmap -p22 $1 | grep open) ]] && [[ -z $(nmap -p222 $1 | grep open) ]];then
            echo "note: system seems to be a linux machine"
            echo ""
         elif [[ -n $(nmap -p3389 $1 | grep open) ]];then
            echo "note: system seems to be a windows server machine"
            echo ""
         fi
         echo "-------------------Availability----------------------"
         fping -e $2
         echo "-----------------------------------------------------"
         echo "-------------------Portscan---------------------"
         nmap --reason -Pn $2
         echo ""
         fping -c 4 $2
         echo "------------------------------------------------"
         exit
      elif [[ $1 == "-n" ]] || [[ "$1" == "--no" ]];then
         echo "checking connection status for $2"
         if [[ -n $(nmap -p22 $1 | grep open) ]] && [[ -z $(nmap -p222 $1 | grep open) ]];then
            echo "note: system seems to be a linux machine"
            echo ""
         elif [[ -n $(nmap -p3389 $1 | grep open) ]];then
            echo "note: system seems to be a windows server machine"
            echo ""
         fi
         echo "-------------------Availability----------------------"
         fping -e $2
         echo "-----------------------------------------------------"
         exit
      elif [[ $1 == "-6" ]] || [[ "$1" == "--force-ipv6" ]];then
         echo "-6 used, forcing IPv6 portscanning"
         echo "checking connection status for $2"
         if [[ -n $(nmap -6 -p22 $1 | grep open) ]] && [[ -z $(nmap -6 -p222 $1 | grep open) ]];then
            echo "note: system seems to be a linux machine"
            echo ""
         elif [[ -n $(nmap -6 -p3389 $1 | grep open) ]];then
            echo "note: system seems to be a windows server machine"
            echo ""
         fi
         echo "-------------------Availability----------------------"
         fping -6 -e $2
         echo "-----------------------------------------------------"
         echo "-------------------Portscan---------------------"
         nmap --reason -Pn -6 $2
         echo ""
         fping -6 -c 4 $2
         echo "------------------------------------------------"
         exit
      elif [[ $1 == "-4" ]] || [[ "$1" == "--force-ipv4" ]];then
         echo "-4 used, forcing IPv4 portscanning"
         echo "checking connection status for $2"
         if [[ -n $(nmap -p22 $1 | grep open) ]] && [[ -z $(nmap -p222 $1 | grep open) ]];then
            echo "note: system seems to be a linux machine"
            echo ""
         elif [[ -n $(nmap -p3389 $1 | grep open) ]];then
            echo "note: system seems to be a windows server machine"
            echo ""
         fi
         echo "-------------------Availability----------------------"
         fping -4 -e $2
         echo "-----------------------------------------------------"
         echo "-------------------Portscan---------------------"
         nmap --reason -Pn $2
         echo ""
         fping -6 -c 4 $2
         echo "------------------------------------------------"
         exit
      elif [[ $1 == "-u" ]] || [[ "$1" == "--update" ]];then
         if [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/conn.sh | md5sum | cut -c -32) != $(md5sum $0 | cut -c -32) ]];then
           wget -O $0 --quiet "https://raw.githubusercontent.com/byReqz/conn/main/conn.sh"
           echo "#############################################"
           echo -e "\e[4mscript has been updated to the newest version\e[0m"
           echo "#############################################"
           exit
         elif [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/conn.sh | md5sum | cut -c -32) = $(md5sum $0 | cut -c -32) ]];then
           echo "#############################################"
           echo "no newer version found"
           echo "#############################################"
           exit
         fi
      elif [[ "$1" == "-w" ]] || [[ "$1" == "--wait" ]];then
         echo "-w used, waiting for active connection"
         echo "checking connection status for $2"
         if [[ -n $(nmap -p22 $1 | grep open) ]] && [[ -z $(nmap -p222 $1 | grep open) ]];then
            echo "note: system seems to be a linux machine"
            echo ""
         elif [[ -n $(nmap -p3389 $1 | grep open) ]];then
            echo "note: system seems to be a windows server machine, it might not respond to icmp"
            echo ""
         fi
         while [[ "$(fping -m -q -u $2)" == "$2" ]]; do :
            done
         notify-send "$2 is now reachable" -u normal -t 15000 -a conn
         if [[ -n $(nmap -p22 $1 | grep open) ]] && [[ -z $(nmap -p222 $1 | grep open) ]];then
            notify-send "$2 seems to be booted into a linux install" -t 15000 -a conn -u normal
         elif [[ -n $(nmap -p3389 $1 | grep open) ]];then
            notify-send "$2 seems to be booted into a windows install" -t 15000 -a conn -u normal
         fi
         echo "-------------------Availability----------------------"
         fping -e $2
         echo "-----------------------------------------------------"
         echo "portscan? (y/n) (default: y)"
            read portscan
            if [[ "$portscan" = "y" ]] || [[ -z "$portscan" ]]; then
               echo "-------------------Portscan---------------------"
               nmap --reason -Pn $2
               echo ""
               fping -c 4 $2
               echo "------------------------------------------------"
               exit
            else
               exit
            fi
         exit
      elif [[ ! "$1" =~ [0-9]{1,3}(\.[0-9]{1,3}){3} ]] && [[ "$1" =~ [:] ]] && [[ ! "$2" =~ [:] ]] && [[ -z "$3" ]];then
         echo "detected IPv6 adress -> using -6"
         echo "checking connection status for $1"
         if [[ -n $(nmap -6 -p22 $1 | grep open) ]] && [[ -z $(nmap -6 -p222 $1 | grep open) ]];then
            echo "note: system seems to be a linux machine"
            echo ""
         elif [[ -n $(nmap -6 -p3389 $1 | grep open) ]];then
            echo "note: system seems to be a windows server machine"
            echo ""
         fi
         echo "-------------------Availability----------------------"
         fping -6 -e $1
         echo "-----------------------------------------------------"
         echo "portscan? (y/n) (default: y)"
            read portscan
            if [[ "$portscan" = "y" ]] || [[ -z "$portscan" ]]; then
               echo "-------------------Portscan---------------------"
               nmap --reason -Pn -6 $1
               echo ""
               fping -6 -c 4 $1
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
         if [[ -n $(nmap -p22 $1 | grep open) ]] && [[ -z $(nmap -p222 $1 | grep open) ]];then
            echo "note: system seems to be a linux machine"
            echo ""
         elif [[ -n $(nmap -p3389 $1 | grep open) ]];then
            echo "note: system seems to be a windows server machine"
            echo ""
         fi
         echo "-------------------Availability----------------------"
         fping -e $1
         echo "-----------------------------------------------------"
         echo "portscan? (y/n) (default: y)"
            read portscan
            if [[ "$portscan" = "y" ]] || [[ -z "$portscan" ]]; then
               echo "-------------------Portscan---------------------"
               nmap --reason -Pn $1
               echo ""
               fping -c 4 $1
               echo "------------------------------------------------"
               exit
            else
               exit
            fi
   fi
   done
