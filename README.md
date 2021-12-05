# conn

quick and dirty server availability check <br> <br>
basically just a way too complex wrapper for nmap and fping <br>

### features: 
- ~~multi-input detection~~ (not needed anymore since the rewrite)
- ~~ipv4 input detection~~ (not needed anymore since the rewrite)
- ~~ipv6 input detection~~ (not needed anymore since the rewrite)
- waiting for availability
- send notification on availability
- updater built in

# usage
Usage: conn <args> [IP(s)/hostname(s)] <br>
Options: <br>
  -h / --help       show help page (this) <br>
  -6 / --force-ipv6 force ipv6 portscanning (also forces portscanning) <br>
  -4 / --force-ipv4 force ipv4 portscanning (also forces portscanning) <br>
  -y / --yes        portscan without asking <br>
  -n / --no         dont portscan <br>
  -w / --wait       wait for active connection <br>
  -u / --update     update the script <br>
  -f / --fast       disable os check <br>
  -s / --simple     simplify output <br>

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
./conn.sh nils.lol
checking connection status for nils.lol
-------------------Availability----------------------
nils.lol is alive (35.5 ms)
note: this seems to be a linux machine
-----------------------------------------------------
portscan? (y/n) (default: y)

-------------------Portscan---------------------
Starting Nmap 7.92 ( https://nmap.org ) at 2021-12-05 13:42 CET
Nmap scan report for nils.lol (168.119.185.158)
Host is up, received user-set (0.048s latency).
Not shown: 995 filtered tcp ports (no-response)
PORT    STATE  SERVICE   REASON
21/tcp  open   ftp       syn-ack
22/tcp  open   ssh       syn-ack
80/tcp  open   http      syn-ack
81/tcp  closed hosts2-ns conn-refused
443/tcp open   https     syn-ack

Nmap done: 1 IP address (1 host up) scanned in 5.54 seconds

nils.lol : [0], 64 bytes, 36.5 ms (36.5 avg, 0% loss)
nils.lol : [1], 64 bytes, 35.7 ms (36.1 avg, 0% loss)
nils.lol : [2], 64 bytes, 34.7 ms (35.6 avg, 0% loss)
nils.lol : [3], 64 bytes, 33.5 ms (35.1 avg, 0% loss)

nils.lol : xmt/rcv/%loss = 4/4/0%, min/avg/max = 33.5/35.1/36.5
------------------------------------------------
```
