# PICO 4 Paper Tracker Autostart

Magisk module that auto-starts the **Bridge Paper Tracker** (`com.bridge.papertracker`) on the PICO 4 (A8110) after boot.

PICO 4 开机自动启动 **Paper Tracker**(追踪器) 的 Magisk 模块。

## Features / 特性

- Waits for the system to finish booting (`sys.boot_completed`).
- Extra wait for the rendering stack / vrshell to settle and for the **see-through** (passthrough) / first-time lab setup to exit before launching.
- Starts `com.bridge.papertracker` with up to 5 retries.
- Runtime toggle: enable / disable without editing the script.

## Requirements / 环境要求

- PICO 4 (A8110), rooted
- Magisk (with module support)
- Paper Tracker app installed (`com.bridge.papertracker`)

## Installation / 安装

1. Push the module directory to the device, or pack the folder as a zip and install via Magisk Manager (`Install from storage`):

   ```
   adb push paper_autostart.zip /sdcard/
   # then install from the zip in Magisk Manager
   ```

2. Reboot. Paper Tracker will auto-start ~15–25s after boot.

## Configuration / 配置

The module reads an `enable` file in its own module directory. Set it to `1` (enable) or `0` (disable). It defaults to enabled on first run.

用自带的开关脚本（在模块目录内执行）:

```sh
# 查看状态
sh toggle.sh
# 启用
echo 1 > enable
# 禁用
echo 0 > enable
# 禁用后立即停止本次启动（通过 toggle）
sh toggle.sh off
```

`toggle.sh` 说明（在模块目录内执行）:

```sh
sh toggle.sh enable     # 启用自启
sh toggle.sh disable    # 禁用自启
sh toggle.sh            # 显示用法
```

Note: changing `enable` takes effect on the next boot.

## File layout / 文件结构

```
paper_autostart/
├── module.prop    # Magisk 模块描述
├── service.sh     # 开机自启逻辑 (boot_completed + see-through 等待 + 重试)
└── toggle.sh      # 启停开关脚本
```

## How it works / 工作原理

`service.sh`:

1. Wait up to 60s for `sys.boot_completed=1`.
2. Wait another ~20s for the see-through / lab setup to finish so Paper is not blocked.
3. Launch `com.bridge.papertracker` up to 5 times (with waits), stopping once the process is detected.

## License

MIT
