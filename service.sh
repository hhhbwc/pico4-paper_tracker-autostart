#!/system/bin/sh
# Paper Tracker autostart v2 - 等待系统完全就绪后再启动
MODDIR=${0%/*}
LOG="$MODDIR/autostart.log"

ENABLE_FILE="$MODDIR/enable"
[ -f "$ENABLE_FILE" ] || echo -n "1" > "$ENABLE_FILE"
[ "$(cat "$ENABLE_FILE")" = "1" ] || exit 0

log(){ echo "[$(date +%H:%M:%S)] $*" >> "$LOG"; }

# 1) 等 boot_completed
n=0
while [ $n -lt 60 ]; do
    [ "$(getprop sys.boot_completed)" = "1" ] && break
    n=$((n+1)); sleep 1
done
log "boot_completed=$n"

# 2) 额外等待系统渲染稳定(等 vrshell 主界面&已退出 see-through)
#    约 15~25s(取决于开机速度)
sleep 20

# 3) 尝试启动 Paper, 失败则重试几次(等待更久)
for i in 1 2 3 4 5; do
    out=$(am start -n com.bridge.papertracker/com.bridge.papertrackermodern.MainActivity 2>&1)
    log "attempt#$i: $out"
    # 检查进程是否存在
    if pgrep -f "com.bridge.papertracker" >/dev/null 2>&1; then
        log "paper running"
        break
    fi
    sleep 10
done

exit 0
