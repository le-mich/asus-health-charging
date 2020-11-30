# Asus health charging _on Linux_

Since there is no official program to manage the battery level from Asus
and since TLP will not provide it because it doesn't follow the standard,
I made my own!

## Install
An install script is provided, run it with `sudo`.
If for some reason the script doesn't find the interface file,
it's possible to override the interface search stage by
using the option `--interface /<path>/<to>/<your>/charge_control_end_threshold`.

__If__ you have systemd, you can then start and enable the service.


## Manual install
___It is highly recommended that you place the script in `/usr/bin` as it is used
in the rest of the project as script location.___

From a root shell create folder `/etc/asus-health-charging.d/`.
```
# mkdir /etc/asus-health-charging.d
```

Find the interface and configure the program:
```
# echo $(find -L /sys/class/power_supply -maxdepth 2 -type f -name 'charge_control_end_threshold' 2> /dev/null) > /etc/asus-health-charging.d/interface
```

Install the script (assuming `pwd` is the local clone of this repository):
```
# cp ./asus-health-charging /usr/bin
```

__If__ your OS uses systemd, install the unit file:
```
# cp ./asus-health-charging /etc/systemd/system
```

Start and enable the service:
```
# systemctl start asus-health-charging.service
# systemctl enable asus-health-charging.service
```

_At last_, install the man page:
```
# cp ./asus-health-charging /usr/share/man/man1
```


## Usage
You can launch the script with (e.g. 60%):
```
$ sudo asus-health-charging 60
```

This command will set the battery level at which the system will stop charging.
If the actual battery level is already beyond this threshold it will not be decreased.

With this one command the script will place the value inside `charge_control_end_threshold`
under `/sys` for immediate control and the file `percentage` in `/etc/asus-health-charging.d`
for restore on startup.

This command will test the nuber used, values must be between 15 and 100 (included).

The lower bound is because LiPo batteries suffer when discharged too much, and because _I'm opinionated_.

### __--restore__
__If__ you have systemd, the provided Unit file once enabled will restore the
last session automatically, once enabled.

At startup it will run once and return. It is then possible to change threshold freely.

If you don't use systemd or want to use a different method to restore the charge limit
you can use
```
$ sudo asus-health-charging --restore
```

### __--current__
Created to be used inside panel widgets and similar,
returns the value stored in `charge_control_end_threshold`.

---
## To do
- [x] Script
- [x] README
- [x] Systemd service
- [x] Install script
- [x] Manpage
- [ ] Applet for Budgie (or the latest DE I'm using, we'll see)
