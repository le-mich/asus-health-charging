#! /bin/bash

# Variables
REPO_DIR=$(echo $0 | rev | cut -d"/" -f2- | rev)
CONF_DIR="/etc/asus-health-charging.d"
BIN_DIR="/usr/bin"
UNIT_DIR="/etc/systemd/system"
MAN_DIR="/usr/share/man/man1"

if [[ $1 == "--interface" ]]
then
echo "Using provided interface: \"$2\"."
	INTERFACE="$2"
else
	echo "Looking for interface in /sys/class/power_supply.."
	INTERFACE=$(find -L /sys/class/power_supply -maxdepth 2 -type f -name 'charge_control_end_threshold' 2> /dev/null | head -1)

	if [[ -n "$INTERFACE" ]]
	then
		echo "Interface found!"
	else
		>&2 echo "Your system seems to be incompatible!"
		>&2 echo "If sure of compatibility, please try --interface option or perform a manual install."
		exit 1
	fi
fi

echo ""

echo "Creating configuration directory \"$CONF_DIR\"."
mkdir -p "$CONF_DIR"

echo ""

if [[ ! -f "$CONF_DIR/interface" ]]
then
	echo "Creating interface file."
	echo "$INTERFACE" > "$CONF_DIR/interface"
else
	echo "Interface file exists already, moving on."
fi

echo ""

echo "Installing script in \"$BIN_DIR\"."
cp -f "$REPO_DIR/asus-health-charging" "$BIN_DIR"

echo ""

if [[ -d "$UNIT_DIR" ]]
then
	echo "Installing Unit file in \"$UNIT_DIR\"."
	cp -f "$REPO_DIR/asus-health-charging.service" "$UNIT_DIR"
fi

echo ""

if [[ -d "$MAN_DIR" ]]
then
	echo "Installing manpage in \"$MAN_DIR\"."
	cp -f "$REPO_DIR/asus-health-charging.1" "$MAN_DIR"
fi

echo ""

echo "All done!"
