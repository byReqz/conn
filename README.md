# conn
quick and dirty server availability check <br> <br>
basically just a way too complex wrapper for nmap and fping <br>

### features: 
- multi-input detection
- ipv4 input detection
- ipv6 input detection
- waiting for availability
- send notification on availability
- updater built in

# usage
Usage: conn (options) [ip] <br>
Options: <br>
 -m/--multi -- test multiple ips / disable portscan <br>
 -h/--help -- show help <br>
 -6/--force-ipv6 -- force ipv6 portscanning (also forces portscanning) <br>
 -4/--force-ipv4 -- force ipv4 portscanning (also forces portscanning) <br>
 -y/--yes -- portscan without asking <br>
 -n/--no -- dont portscan <br>
 -p/--portscan -- same as -y <br>
 -w/--wait -- wait for active connection <br>
 -u/--update -- update the script <br>
 -f/ --fast -- disable os check <br>
 -s/ --simple -- same as -f <br>

# installation
1. download the script: <br>
```bash
wget https://git.byreqz.de/byreqz/conn/raw/branch/main/conn.sh
```
2. run it with <br>
``
bash conn.sh
``
or <br>
``
chmod +x conn.sh && ./conn.sh
``
3. optionally alias it <br>
``alias conn="~/conn.sh"``
