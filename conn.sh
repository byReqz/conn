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
  get_args $@
  set_argvars $args
  validate $input
}

function get_args {
  input=$(echo "$@")
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
    only6=true
  fi
  if [[ $@ =~ -4 ]] || [[ $@ =~ --force-ipv4 ]];then
    only4=true
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
  true
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