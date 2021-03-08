#!/bin/bash
# license: gpl-3

if [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/hash) != $(md5sum $0 | cut -c -32) ]] && [[ -z $1 ]] || [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/hash) != $(md5sum $0 | cut -c -32) ]] && [[ $1 != "--update" ]] || [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/hash) != $(md5sum $0 | cut -c -32) ]] && [[ $1 != "-u" ]];then
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
         echo " -f/ --fast -- disable os check"
         echo " -s/ --simple -- same as -f"
         echo " -ww/ --wait-windows -- same as -w but for windows machines"
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
         echo " -f/ --fast -- disable os check"
         echo " -s/ --simple -- same as -f"
         echo " -ww/ --wait-windows -- same as -w but for windows machines"
         exit
      elif [[ $1 == "-m" ]] || [[ "$1" == "--multi" ]];then
         echo "multi-ip mode, portscan disabled"
         echo "-------------------Availability----------------------"
         fping -e $@
         echo "-----------------------------------------------------"
         exit
      elif [[ $1 == "-f" ]] || [[ "$1" == "--fast" ]] || [[ $1 == "-s" ]] || [[ "$1" == "--simple" ]];then
         echo "$1 used, skipping os check"
         echo "checking connection status for $2"
         echo "-------------------Availability----------------------"
         fping -e $2
         echo "-----------------------------------------------------"
         echo "-------------------Portscan---------------------"
         nmap --reason -Pn $2
         echo ""
         fping -c 4 $2
         echo "------------------------------------------------"
         exit
      elif [[ $1 == "-y" ]] || [[ $1 == "-p" ]] || [[ "$1" == "--portscan" ]] || [[ "$1" == "--yes" ]];then
         echo "checking connection status for $2"
         fping=$(fping -a $2)
         p135=$(nping -q1 -c1 -p135 $2)
         p3389=$(nping -q1 -c1 -p3389 $2)
         if [[ $fping != "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$2" ]] && [[ -n $(echo $p3389 | grep "Successful connections: 1") ]] || [[ $fping = "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "note: this seems to be a windows machine which does not respond to ICMP"
            echo "-----------------------------------------------------"
         elif [[ $fping != "$2" ]] && [[ -z $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$2" ]] && [[ -z $(echo $p3389 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "$2 is not reachable"
            echo "-----------------------------------------------------"
         else
            echo "-------------------Availability----------------------"
            fping -e $2
            rescue=$(nping -q1 -c1 -p22,222 $2)
            if [[ -n $(echo $rescue | grep "Successful connections: 1") ]];then
               echo "note: this seems to be a linux machine"
            elif [[ -n $(echo $rescue | grep "Successful connections: 2") ]];then
               echo "note: this machine seems to be in the rescue system"
            fi
            echo "-----------------------------------------------------"
	      fi
         echo "-------------------Portscan---------------------"
         nmap --reason -Pn $2
         echo ""
         fping -c 4 $2
         echo "------------------------------------------------"
         exit
      elif [[ $1 == "-n" ]] || [[ "$1" == "--no" ]];then
         fping=$(fping -a $2)
         p135=$(nping -q1 -c1 -p135 $2)
         p3389=$(nping -q1 -c1 -p3389 $2)
         if [[ $fping != "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$2" ]] && [[ -n $(echo $p3389 | grep "Successful connections: 1") ]] || [[ $fping = "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "note: this seems to be a windows machine which does not respond to ICMP"
            echo "-----------------------------------------------------"
         elif [[ $fping != "$2" ]] && [[ -z $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$2" ]] && [[ -z $(echo $p3389 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "$2 is not reachable"
            echo "-----------------------------------------------------"
         else
            echo "-------------------Availability----------------------"
            fping -e $2
            rescue=$(nping -q1 -c1 -p22,222 $2)
            if [[ -n $(echo $rescue | grep "Successful connections: 1") ]];then
               echo "note: this seems to be a linux machine"
            elif [[ -n $(echo $rescue | grep "Successful connections: 2") ]];then
               echo "note: this machine seems to be in the rescue system"
            fi
            echo "-----------------------------------------------------"
	      fi
         exit
      elif [[ $1 == "-6" ]] || [[ "$1" == "--force-ipv6" ]];then
         echo "-6 used, forcing IPv6 portscanning"
         if [[ "$2" =~ http ]];then
            echo "url detected, exiting"
            exit
         fi
         echo "checking connection status for $2"
         fping=$(fping -6 -a $2)
         p135=$(nping -6 -q1 -c1 -p135 $2)
         p3389=$(nping -6 -q1 -c1 -p3389 $2)
         if [[ $fping != "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$2" ]] && [[ -n $(echo $p3389 | grep "Successful connections: 1") ]] || [[ $fping = "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "note: this seems to be a windows machine which does not respond to ICMP"
            echo "-----------------------------------------------------"
         elif [[ $fping != "$2" ]] && [[ -z $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$2" ]] && [[ -z $(echo $p3389 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "$2 is not reachable"
            echo "-----------------------------------------------------"
         else
            echo "-------------------Availability----------------------"
            fping -6 -e $2
            rescue=$(nping -6 -q1 -c1 -p22,222 $2)
            if [[ -n $(echo $rescue | grep "Successful connections: 1") ]];then
               echo "note: this seems to be a linux machine"
            elif [[ -n $(echo $rescue | grep "Successful connections: 2") ]];then
               echo "note: this machine seems to be in the rescue system"
            fi
            echo "-----------------------------------------------------"
	      fi
         echo "-------------------Portscan---------------------"
         nmap --reason -Pn -6 $2
         echo ""
         fping -6 -c 4 $2
         echo "------------------------------------------------"
         exit
      elif [[ $1 == "-4" ]] || [[ "$1" == "--force-ipv4" ]];then
         echo "-4 used, forcing IPv4 portscanning"
         echo "checking connection status for $2"
         fping=$(fping -4 -a $2)
         p135=$(nping -4 -q1 -c1 -p135 $2)
         p3389=$(nping -4 -q1 -c1 -p3389 $2)
         if [[ $fping != "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$2" ]] && [[ -n $(echo $p3389 | grep "Successful connections: 1") ]] || [[ $fping = "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "note: this seems to be a windows machine which does not respond to ICMP"
            echo "-----------------------------------------------------"
         elif [[ $fping != "$2" ]] && [[ -z $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$2" ]] && [[ -z $(echo $p3389 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "$2 is not reachable"
            echo "-----------------------------------------------------"
         else
            echo "-------------------Availability----------------------"
            fping -4 -e $2
            rescue=$(nping -4 -q1 -c1 -p22,222 $2)
            if [[ -n $(echo $rescue | grep "Successful connections: 1") ]];then
               echo "note: this seems to be a linux machine"
            elif [[ -n $(echo $rescue | grep "Successful connections: 2") ]];then
               echo "note: this machine seems to be in the rescue system"
            fi
            echo "-----------------------------------------------------"
	      fi
         echo "-------------------Portscan---------------------"
         nmap -4 --reason -Pn $2
         echo ""
         fping -4 -c 4 $2
         echo "------------------------------------------------"
         exit
      elif [[ $1 == "-u" ]] || [[ "$1" == "--update" ]];then
          if [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/hash) != $(md5sum $0 | cut -c -32) ]];then
          wget -O $0 --quiet "https://raw.githubusercontent.com/byReqz/conn/main/conn.sh"
          echo "#############################################"
          echo -e "\e[4mscript has been updated to the newest version\e[0m"
          echo "#############################################"
          exit
        elif [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/hash) = $(md5sum $0 | cut -c -32) ]];then
         echo "#############################################"
         echo "no newer version found"
         echo "#############################################"
         exit
        fi
      elif [[ "$1" == "-w" ]] || [[ "$1" == "--wait" ]];then
         echo "-w used, waiting for active connection"
         echo "checking connection status for $2"
         fping=$(fping -a $2)
         p135=$(nping -q1 -c1 -p135 $2)
         p3389=$(nping -q1 -c1 -p3389 $2)
         if [[ $fping != "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$2" ]] && [[ -n $(echo $p3389 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "note: this seems to be a windows machine which does not respond to ICMP"
            notify-send "$2 is now reachable" "and seems to be a windows machine" -u normal -t 30000 -a conn
            echo "-----------------------------------------------------"
         elif [[ $fping = "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "note: this seems to be a windows machine which does respond to ICMP"
            fping -e $2
            notify-send "$2 is now reachable" "and seems to be a windows machine" -u normal -t 30000 -a conn
            echo "-----------------------------------------------------" 
         else
            while [[ "$(fping -m -q -u $2)" == "$2" ]]; do :
               done
            echo "-------------------Availability----------------------"
            fping -e $2
            rescue=$(nping -q1 -c1 -p22,222 $2)
            if [[ -n $(echo $rescue | grep "Successful connections: 1") ]];then
               echo "note: this seems to be a linux machine"
               notify-send "$2 is now reachable" "and seems to be in a linux system" -u normal -t 30000 -a conn
            elif [[ -n $(echo $rescue | grep "Successful connections: 2") ]];then
               echo "note: this machine seems to be in the rescue system"
               notify-send "$2 is now reachable" "and seems to be in the rescue system" -u normal -t 30000 -a conn
            else
               notify-send "$2 is now reachable" -u normal -t 30000 -a conn
            fi
            echo "-----------------------------------------------------"
	      fi
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
      elif [[ "$1" == "-ww" ]] || [[ "$1" == "--wait-windows" ]];then
         echo "-w used, waiting for active connection"
         echo "checking connection status for $2"
         fping=$(fping -a $2)
         p135=$(nping -q1 -c1 -p135 $2)
         p3389=$(nping -q1 -c1 -p3389 $2)
         if [[ $fping = "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 0") ]];then
            echo "-------------------Availability----------------------"
            echo "note: this seems to be a unix machine which does respond to ICMP"
            notify-send "$2 is a unix machine" -u normal -t 30000 -a conn
            echo "-----------------------------------------------------"
         elif [[ $fping = "$2" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "note: this seems to be a windows machine which does respond to ICMP"
            notify-send "$2 is a windows machine" -u normal -t 30000 -a conn
            echo "-----------------------------------------------------"
         else
            while [[ -z $(nping -q1 -c1 -p135 $2 | grep "Successful connections: 1") ]]; do :
               done
            echo "-------------------Availability----------------------"
            rescue=$(nping -q1 -c1 -p22,222 $2)
            if [[ -n $(echo $rescue | grep "Successful connections: 2") ]];then
               echo "note: this machine seems to be in the rescue system"
               notify-send "$2 is now reachable" "and seems to be in the rescue system" -u normal -t 30000 -a conn
            else
               echo "$2 is now booted into windows"
               notify-send "$2 is now booted into windows" -u normal -t 30000 -a conn
            fi
            echo "-----------------------------------------------------"
	      fi
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
         if [[ "$1" =~ http ]];then
            echo "url detected, exiting"
            exit
         fi
         echo "detected IPv6 adress -> using -6"
         echo "checking connection status for $1"
         fping=$(fping -6 -a $1)
         p135=$(nping -6 -q1 -c1 -p135 $1)
         p3389=$(nping -6 -q1 -c1 -p3389 $1)
         if [[ $fping != "$1" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$1" ]] && [[ -n $(echo $p3389 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "note: this seems to be a windows machine which does not respond to ICMP"
            echo "-----------------------------------------------------"
         elif [[ $fping != "$1" ]] && [[ -z $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping == "$1" ]] && [[ -z $(echo $p3389 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "$2 is not reachable"
            echo "-----------------------------------------------------"
         else
            echo "-------------------Availability----------------------"
            fping -6 -e $1
            rescue=$(nping -6 -q1 -c1 -p22,222 $1)
            if [[ -n $(echo $rescue | grep "Successful connections: 1") ]];then
               echo "note: this seems to be a linux machine"
            elif [[ -n $(echo $rescue | grep "Successful connections: 2") ]];then
               echo "note: this machine seems to be in the rescue system"
            fi
            echo "-----------------------------------------------------"
	      fi
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
         fping=$(fping -a $1)
         p135=$(nping -q1 -c1 -p135 $1)
         p3389=$(nping -q1 -c1 -p3389 $1)
         if [[ $fping != "$1" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$1" ]] && [[ -n $(echo $p3389 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "note: this seems to be a windows machine which does not respond to ICMP"
            echo "-----------------------------------------------------"
         elif [[ $fping != "$1" ]] && [[ -z $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$1" ]] && [[ -z $(echo $p3389 | grep "Successful connections: 1") ]];then
            echo "-------------------Availability----------------------"
            echo "$1 is not reachable"
            echo "-----------------------------------------------------"
         else
            echo "-------------------Availability----------------------"
            fping -e $1
            rescue=$(nping -q1 -c1 -p22,222 $1)
            if [[ -n $(echo $rescue | grep "Successful connections: 1") ]];then
               echo "note: this seems to be a linux machine"
            elif [[ -n $(echo $rescue | grep "Successful connections: 2") ]];then
               echo "note: this machine seems to be in the rescue system"
            fi
            echo "-----------------------------------------------------"
	      fi
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
