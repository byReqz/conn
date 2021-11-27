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
  -s / --simple     simplyfy output"

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

function prepare {
    true
}

function main {
    true
}

if [[ -n $1 ]];then
  prepare
  main
else
  echo "$show_help"
fi