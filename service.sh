#!/system/bin/sh
# Paper Tracker autostart: wait for a stable VR session and honor maintenance locks.
MODDIR=${0%/*}
LOG="$MODDIR/autostart.log"
ENABLE_FILE="$MODDIR/enable"
COORD_DIR="/data/adb/pico4-coord"
SUPPRESS_FILE="$COORD_DIR/paper-autostart.suppress"
MATRIX_LOCK="$COORD_DIR/matrix-switch.lock"
TRACKER_PKG="com.bridge.papertracker"
TRACKER_COMPONENT="com.bridge.papertracker/com.bridge.papertrackermodern.MainActivity"

[ -f "$ENABLE_FILE" ] || echo -n "1" > "$ENABLE_FILE"
[ "$(cat "$ENABLE_FILE" 2>/dev/null)" = "1" ] || exit 0

log() { echo "[$(date +%H:%M:%S)] $*" >> "$LOG"; }
locked() { [ -e "$SUPPRESS_FILE" ] || [ -e "$MATRIX_LOCK" ]; }

n=0
while [ "$n" -lt 90 ]; do
    [ "$(getprop sys.boot_completed)" = "1" ] && break
    n=$((n + 1))
    sleep 1
done
[ "$(getprop sys.boot_completed)" = "1" ] || { log "boot did not complete"; exit 0; }
log "boot completed after ${n}s"

# Let SystemExt and VR Shell establish their initial graphics state before launching Tracker.
sleep 20
for i in 1 2 3 4 5; do
    if locked; then
        log "attempt#$i skipped: maintenance or Matrix transition lock"
        exit 0
    fi
    if ! pm path "$TRACKER_PKG" >/dev/null 2>&1; then
        log "attempt#$i skipped: package missing"
        exit 0
    fi
    if ! cmd package resolve-activity --brief "$TRACKER_COMPONENT" 2>/dev/null | grep -q "$TRACKER_PKG"; then
        log "attempt#$i skipped: component missing"
        exit 0
    fi
    out=$(am start -n "$TRACKER_COMPONENT" 2>&1)
    log "attempt#$i: $out"
    if pgrep -f "$TRACKER_PKG" >/dev/null 2>&1; then
        log "paper running"
        exit 0
    fi
    sleep 10
done
log "paper did not start after retries"
exit 0
