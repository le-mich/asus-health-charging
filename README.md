# Asus health charging
### _on Linux_

Since there is no official program to manage the battery level from Asus
and since TLP will not provide it because it doesn't follow the standard,
I made my own!

## Install
___It is highly recommended that you place the script in one of the folders listed in PATH.___

From a root shell create folder `/etc/asus-health-charging.d/`.

```
# mkdir /etc/asus-health-charging.d
```
And then:

```
# echo $(find -L /sys/class/power_supply -maxdepth 2 -type f -name 'charge_control_end_threshold' 2> /dev/null) > /etc/asus-health-charging.d/interface
```

## Usage
You can now launch the script (e.g. 60%):
```
$ sudo asus-health-charging 60
```

This command will set the battery level at which the system will stop charging.
If the actual battery level is already beyond this threshold it will not be decreased.

With this one command the script will place the value inside `charge_control_end_threshold` under `/sys` for immediate control and the file `percentage` in `/etc/asus-health-charging.d` for restore on startup.

This command will test the nuber used, values must be between 15 and 100 (included). This is because LiPo batteries suffer when discharged too much, and because _I'm opinionated_.

## --restore
As of today I haven't written the systemd service, but it's in the works, in the meantime
```
sudo asus-health-charging --restore
```
will restore the percentage used during the last session.

## --current
Created to be used inside panel widgets and similar,
returns the value stored in `charge_control_end_threshold`.

---
## To do
- [x] Script
- [x] README
- [ ] Systemd service
- [ ] Install script
- [ ] Manpage
- [ ] Applet for Budgie (or the latest DE I'm using)