# conn

__this branch has been merged into main and is no longer maintained__

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

# sample output
```bash
checking connection status for localhost
-------------------Availability----------------------
localhost is alive (545 ms)
note: this seems to be a linux machine
-----------------------------------------------------
-------------------Portscan---------------------
Starting Nmap 7.91 ( https://nmap.org ) at 2021-02-15 15:07 CET
Nmap scan report for localhost (127.0.0.1)
Host is up, received user-set (0.047s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 998 closed ports
Reason: 998 conn-refused
PORT    STATE SERVICE REASON
22/tcp  open  ssh     syn-ack
631/tcp open  ipp     syn-ack
Nmap done: 1 IP address (1 host up) scanned in 3.23 seconds

localhost : [0], 64 bytes, 0.185 ms (0.185 avg, 0% loss)
localhost : [1], 64 bytes, 0.058 ms (0.122 avg, 0% loss)
localhost : [2], 64 bytes, 0.060 ms (0.101 avg, 0% loss)
localhost : [3], 64 bytes, 0.081 ms (0.096 avg, 0% loss)

localhost : xmt/rcv/%loss = 4/4/0%, min/avg/max = 0.058/0.096/0.185
------------------------------------------------
```
