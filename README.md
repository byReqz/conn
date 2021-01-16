# conn
quick and dirty server availability check <br>
### features: <br>
- multi-input detection
- ipv4 input detection
- ipv6 input detection
- waiting for availability
- send notification on availability

requires fping and nmap (and bash)

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
