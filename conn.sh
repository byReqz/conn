while [ ! -z "$1" ]; do
   if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]];then
      echo "Usage: $0 (-m) <ip> (y/n)"
      echo "Options:"
      echo " -m/--multi -- test multiple ips / disable portscan"
      printf " -h/--help -- show help"
      exit
   elif [[ $1 == "-m" ]] || [[ "$1" == "--multi" ]];then
      echo "multi-ip mode, portscan disabled"
      echo "-------------------Availability----------------------"
      fping $@
      echo "-----------------------------------------------------"
      exit
   elif [[ $1 == "-y" ]] || [[ $1 == "-p" ]] || [[ "$1" == "--portscan" ]] || [[ "$1" == "--yes" ]];then
      echo "checking connection status for $2"
      echo "-------------------Availability----------------------"
      fping $2
      echo "-----------------------------------------------------"
      echo "-------------------Portscan---------------------"
      nmap -Pn $2
      fping -c 4 -A $2
      echo "------------------------------------------------"
      exit
   elif [[ $1 == "-n" ]] || [[ "$1" == "--no" ]];then
    echo "checking connection status for $2"
    echo "-------------------Availability----------------------"
    fping $2
    echo "-----------------------------------------------------"
      exit
   else
      echo "checking connection status for $1"
      echo "-------------------Availability----------------------"
      fping $1
      echo "-----------------------------------------------------"
      echo "portscan? (y/n) (default: y)"
      read portscan
      if [[ "$portscan" = "y" ]] || [[ -z "$portscan" ]]; then
      echo "-------------------Portscan---------------------"
      nmap -Pn $1
      fping -c 4 -A $1
      echo "------------------------------------------------"
      exit
      elif [[ "$portscan" = "n" ]]; then
      exit
      fi
fi
done