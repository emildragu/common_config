
# Traffic controll linux - notes

<!-- vscode-markdown-toc -->
* [Sample usage](#Sampleusage)
	* [adding a queuing discipline to a device](#addingaqueuingdisciplinetoadevice)
	* [ add a class to an existing parent class.](#addaclasstoanexistingparentclass.)
* [Using tcconfig](#Usingtcconfig)
	* [This creates and simulated drop of packets](#Thiscreatesandsimulateddropofpackets)
	* [NOTE: when setting this keep in mind that it applies only for EGRESS traffic. For example, when testing this on vagrant it only applies if you copy something from vagrant box to outside](#NOTE:whensettingthiskeepinmindthatitappliesonlyforEGRESStraffic.Forexamplewhentestingthisonvagrantitonlyappliesifyoucopysomethingfromvagrantboxtooutside)
	* [Download rate limiting](#Downloadratelimiting)
	* [Export settings](#Exportsettings)
	* [Get commands tc commands that tcconfig runs by using --tc-command](#Getcommandstccommandsthattcconfigrunsbyusing--tc-command)
	* [Deleting configuration](#Deletingconfiguration)
* [Backup and restore](#Backupandrestore)
* [See also](#Seealso)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Sampleusage'></a>Sample usage

### <a name='addingaqueuingdisciplinetoadevice'></a>adding a queuing discipline to a device
```bash
tc qdisc add             \ # Add a queueing discipline (could also be del)
            dev eth0     \ # On which device
            root         \ # root is egress
            handle 1:0   \ # handle speciffied as major:minor
            htb            # the queuing discipline to attach, HTB in this example
```

### <a name='addaclasstoanexistingparentclass.'></a> add a class to an existing parent class. 
```bash
tc qdisc add             \ # Add a queueing discipline (could also be del)
            dev eth0     \ # On which device
            parent 1:1   \ # parent discipline
            classid 1:6  \ # handle speciffied as major:minor
            htb          \ # the queuing discipline to attach, HTB in this example
            rate 256kbit \ #
            ceil 512kbit   #
```

## <a name='Usingtcconfig'></a>Using tcconfig
* Setup
```
git clone https://github.com/thombashi/tcconfig.git
cd tcconfig
# use venv
pip install -r requirements/requirements.txt 
```

### <a name='Thiscreatesandsimulateddropofpackets'></a>This creates and simulated drop of packets
```
python3 cli_tcset.py  --device eth0 --loss 0.1% --overwrite
```

### <a name='NOTE:whensettingthiskeepinmindthatitappliesonlyforEGRESStraffic.Forexamplewhentestingthisonvagrantitonlyappliesifyoucopysomethingfromvagrantboxtooutside'></a>NOTE: when setting this keep in mind that it applies only for EGRESS traffic. For example, when testing this on vagrant it only applies if you copy something from vagrant box to outside
```
python3 cli_tcset.py  --device eth0 --rate 100Kbps --overwrite
```

### <a name='Downloadratelimiting'></a>Download rate limiting
```
python3 cli_tcset.py  --device eth0 --direction incoming --rate 1000Kbps  --overwrite
```
### <a name='Exportsettings'></a>Export settings
Exports to SQLITE 3 database
```
python3 cli_tcshow.py  --device eth0 --export here.sqlite3
{
    "eth0": {
        "outgoing": {},
        "incoming": {
            "protocol=ip": {
                "filter_id": "800::800",
                "rate": "2001Kbps"
            }
        }
    }
}

```
Just display configuration
```
python3 cli_tcshow.py  --device eth0
```
### <a name='Getcommandstccommandsthattcconfigrunsbyusing--tc-command'></a>Get commands tc commands that tcconfig runs by using --tc-command
These commands are not ran they are just outputed.
```
python3 cli_tcset.py  --device eth0 --direction incoming --rate 2001Kbps --overwrite --tc-command

/usr/sbin/tc qdisc del dev eth0 root
/usr/sbin/tc qdisc del dev eth0 ingress
/usr/sbin/tc qdisc del dev ifb6682 root
/usr/bin/ip link set dev ifb6682 down
/usr/bin/ip link delete ifb6682 type ifb
modprobe ifb
/usr/bin/ip link add ifb6682 type ifb
/usr/bin/ip link set dev ifb6682 up
/usr/sbin/tc qdisc add dev eth0 ingress
/usr/sbin/tc filter add dev eth0 parent ffff: protocol ip u32 match u32 0 0 flowid 1a1a: action mirred egress redirect dev ifb6682
/usr/sbin/tc qdisc add dev ifb6682 root handle 1a1a: htb default 1
/usr/sbin/tc class add dev ifb6682 parent 1a1a: classid 1a1a:1 htb rate 32000000.0kbit
/usr/sbin/tc class add dev ifb6682 parent 1a1a: classid 1a1a:215 htb rate 2001.0Kbit ceil 2001.0Kbit burst 250.125KB cburst 250.125KB
/usr/sbin/tc qdisc add dev ifb6682 parent 1a1a:215 handle 28f9: netem
/usr/sbin/tc filter add dev ifb6682 protocol ip parent 1a1a: prio 5 u32 match ip dst 0.0.0.0/0 match ip src 0.0.0.0/0 flowid 1a1a:215

```

### <a name='Deletingconfiguration'></a>Deleting configuration

```
python3 cli_tcdel.py  --device eth0 --all
```
Delete by filter_id. See tcshow export for more details on search parameters
```
python3 cli_tcdel.py  --device eth0 --id 800::801

```
## <a name='Backupandrestore'></a>Backup and restore

Dump
```
python3 cli_tcshow.py --device eth0 > tcconfig.json
```

Import
```
python3 cli_tcset.py tcconfig.json --import-setting
```

See more commands on repo's readme page: 
https://github.com/thombashi/tcconfig#set-traffic-control-tcset-command
https://tcconfig.readthedocs.io/en/latest/

## <a name='Seealso'></a>See also
- `iproute2` tools
- https://github.com/thombashi/tcconfig.git - high level wrapper