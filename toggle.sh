#!/system/bin/sh
# Manual toggle for Paper autostart
MODDIR=$(dirname "$0")
case "$1" in
  enable)  echo -n "1" > "$MODDIR/enable"; echo "Paper autostart ENABLED";;
  disable) echo -n "0" > "$MODDIR/enable"; echo "Paper autostart DISABLED";;
  *) echo "Usage: $0 enable|disable";;
esac
