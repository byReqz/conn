#!/bin/bash
# license: gpl-3

show_help="conn: a quick and dirty server availability check

usage:
  "$0" <args> [IP(s)/hostname(s)]

arguments:
  -h / --help       show help page (this)
  -6 / --force-ipv6 force ipv6 portscanning (also forces portscanning)
  -4 / --force-ipv4 force ipv4 portscanning (also forces portscanning)
  -y / --yes        portscan without asking
  -n / --no         dont portscan
  -w / --wait       wait for active connection
  -u / --update     update the script
  -f / --fast       disable os check
  -s / --simple     simplify output"

show_notfound="[error] argument not found

available arguments:
  -h / --help       show help page (this)
  -6 / --force-ipv6 force ipv6 portscanning (also forces portscanning)
  -4 / --force-ipv4 force ipv4 portscanning (also forces portscanning)
  -y / --yes        portscan without asking
  -n / --no         dont portscan
  -w / --wait       wait for active connection
  -u / --update     update the script
  -f / --fast       disable os check
  -s / --simple     simplify output"

function check_update {
  if [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/hash) != $(md5sum $0 | cut -c -32) ]] && [[ -z $1 ]] || [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/hash) != $(md5sum $0 | cut -c -32) ]] && [[ $1 != "--update" ]] || [[ $(curl -s https://raw.githubusercontent.com/byReqz/conn/main/hash) != $(md5sum $0 | cut -c -32) ]] && [[ $1 != "-u" ]];then
    echo "#############################################"
    echo -e "\e[4mnote: newer version detected, use -u to update\e[0m"
    echo "#############################################"
    echo ""
  fi
}

function run_update {
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
}

function prepare {
  #check_update
  get_args "$@"
  set_argvars $args
  validate $input
}

function get_args {
  input=$(echo " $@")
  args=$(echo "$input" | grep -o -e "-h" -e "--help" -e "-6" -e "--force-ipv6" -e "-4" -e "--force-ipv4" -e "-y" -e "--yes" -e "-n" -e "--no" -e "-w" -e "--wait" -e "-u" -e "--update" -e "-f" -e "--fast" -e "-s" -e "--simple" | xargs)
  for arg in $args; do
    input=$(echo "$input" | sed "s/$arg//g")
  done

# needs work
#  argcheck=$(echo $input | grep -o -e " -* " | xargs)
#  echo $argcheck
#  if [[ -n "$argcheck" ]];then
#    for arg in $argcheck; do
#      echo "the given argument \""$arg"\" is not known"
#    done
#  fi
}

function set_argvars {
  if [[ $@ =~ -6 ]] || [[ $@ =~ --force-ipv6 ]];then
    only="-6"
  fi
  if [[ $@ =~ -4 ]] || [[ $@ =~ --force-ipv4 ]];then
    only="-4"
  fi
  if [[ $@ =~ -y ]] || [[ $@ =~ --yes ]];then
    doportscan=true
  fi
  if [[ $@ =~ -n ]] || [[ $@ =~ --no ]];then
    doportscan=false
  fi
  if [[ $@ =~ -s ]] || [[ $@ =~ --simple ]];then
    simpleoutput=true
  fi
  if [[ $@ =~ -w ]] || [[ $@ =~ --wait ]];then
    waitcheck=true
  fi
  if [[ $@ =~ -f ]] || [[ $@ =~ --fast ]];then
    oscheck=false
  fi
}

function validate {
  for arg in $@; do
    if $(ip route show "$arg" 2&> /dev/null);then
      hosts="$hosts $arg"
    elif $(nslookup "$arg" > /dev/null);then
      hosts="$hosts $arg"
    else
      echo "invalid input: $arg"
    fi
  done
}

function main {
  if [[ $simpleoutput == true ]] && [[ -n $hosts ]];then
    echo "-------------------Availability----------------------"
    fping $only -e $@
    quickport=$(nping $only -c1 -p22,222,3389,135 $@ | grep -e "completed")
    if [[ -n $quickport ]];then
      echo ""
      echo "$quickport"
    fi
    echo "-----------------------------------------------------"
  else
    for host in $hosts;do
      echo "checking connection status for $host"
      fping=$(fping $only -a $host)
      if [[ ! $oscheck == false ]];then
        p135=$(nping $only -q1 -c1 -p135 $host)
        p3389=$(nping $only -q1 -c1 -p3389 $host)
      fi
      if [[ $fping != "$host" ]] && [[ -n $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$host" ]] && [[ -n $(echo $p3389 | grep "Successful connections: 1") ]];then
        echo "-------------------Availability----------------------"
        echo "note: this seems to be a windows machine which does not respond to ICMP"
        echo "-----------------------------------------------------"
      elif [[ $fping != "$host" ]] && [[ -z $(echo $p135 | grep "Successful connections: 1") ]] || [[ $fping != "$host" ]] && [[ -z $(echo $p3389 | grep "Successful connections: 1") ]];then
        echo "-------------------Availability----------------------"
        echo "$host is not reachable"
        echo "-----------------------------------------------------"
      else
        echo "-------------------Availability----------------------"
        fping $only -e $host
        if [[ ! $oscheck == false ]];then
          rescue=$(nping $only -q1 -c1 -p22,222 $host)
          if [[ -n $(echo $rescue | grep "Successful connections: 1") ]];then
            echo "note: this seems to be a linux machine"
          elif [[ -n $(echo $rescue | grep "Successful connections: 2") ]];then
            echo "note: this machine seems to be in the rescue system"
          elif [[ -n $(echo $p135 | grep "Successful connections: 1") ]] || [[ -n $(echo $p3389 | grep "Successful connections: 1") ]];then
            echo "note: this machine seems to be booted into windows"
          fi
        fi
        echo "-----------------------------------------------------"
      fi
      if [[ ! $doportscan == false ]];then
        if [[ $doportscan == true ]];then
          portscan=y
        else
          echo "portscan? (y/n) (default: y)"
          read portscan
        fi
        if [[ "$portscan" = "y" ]] || [[ -z "$portscan" ]]; then
          echo "-------------------Portscan---------------------"
          nmap $only --reason -Pn $host
          echo ""
          fping $only -c 4 $host
          echo "------------------------------------------------"
          exit
        else
          echo ""
        fi
      fi
    done
  fi
}

if [[ -n $1 ]];then
  prepare "$@"
  main "$hosts"
elif [[ "$1" == "-u" ]];then
  run_update
elif [[ "$1" == "-h" ]];then
  check_update
  echo "$show_help"
else
  #check_update
  echo "$show_help"
fi