# PICO 4 Paper Tracker Autostart

A Magisk module that auto-starts the **Bridge Paper Tracker** (`com.bridge.papertracker`) on the PICO 4 (A8110) after boot.

> 中文: [README.md](README.md) · Русский: [README.ru-RU.md](README.ru-RU.md)

## Features

- Waits for the system to finish booting (`sys.boot_completed`).
- Extra wait for the rendering stack / vrshell to settle and for the **see-through** (passthrough) / first-time lab setup to exit before launching.
- Starts `com.bridge.papertracker` with up to 5 retries.
- Runtime toggle: enable / disable without editing the script.

## Requirements

- PICO 4 (A8110), rooted
- Magisk with module support
- Paper Tracker app installed (`com.bridge.papertracker`)

## Installation

1. Push the module directory as a zip (or the folder) and install via Magisk Manager (`Install from storage`):

   ```
   adb push paper_autostart.zip /sdcard/
   # then install from the zip in Magisk Manager
   ```

2. Reboot. Paper Tracker will auto-start ~15–25s after boot.

## Configuration

The module reads an `enable` file in its own directory. Set it to `1` (enable) or `0` (disable). It defaults to enabled on first run.

Run `toggle.sh` inside the module directory:

```sh
sh toggle.sh enable     # enable autostart
sh toggle.sh disable    # disable autostart
sh toggle.sh            # show usage
```

> Note: changing `enable` takes effect on the next boot.

## File layout

```
paper_autostart/
├── module.prop    # Magisk module metadata
├── service.sh     # boot autostart logic (boot_completed + see-through wait + retry)
└── toggle.sh      # enable/disable script
```

## How it works

`service.sh`:

1. Wait up to 60s for `sys.boot_completed=1`.
2. Wait another ~20s for the see-through / lab setup to finish so Paper is not blocked.
3. Launch `com.bridge.papertracker` up to 5 times (with waits), stopping once the process is detected.

## License

MIT
