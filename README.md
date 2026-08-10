# PICO 4 Paper Tracker 开机自启

一个在 **PICO 4（A8110）** 上开机后自动启动 **Bridge Paper Tracker**（`com.bridge.papertracker`）的 Magisk 模块。

> English: [README.en-US.md](README.en-US.md) · Русский: [README.ru-RU.md](README.ru-RU.md)

## 特性

- 等待系统完全开机（`sys.boot_completed`）。
- 额外等待渲染栈 / vrshell 稳定、并退出 **see-through**（透视）首次实验室设置后再启动。
- 启动 `com.bridge.papertracker`，最多重试 5 次。
- 运行时开关：无需改脚本即可启用 / 禁用。

## 环境要求

- PICO 4（A8110），已 root
- 已安装 Magisk（支持模块）
- 已安装 Paper Tracker 应用（`com.bridge.papertracker`）

## 安装

1. 把模块目录打包成 zip 或整体推送，再用 Magisk Manager「从存储安装」：

   ```
   adb push paper_autostart.zip /sdcard/
   # 然后在 Magisk Manager 里从该 zip 安装
   ```

2. 重启。Paper Tracker 会在开机约 15–25 秒后自动启动。

## 配置

模块在其自身目录里读取一个 `enable` 文件：写 `1`（启用）或 `0`（禁用）。首次运行默认为启用。

在模块目录内执行 `toggle.sh`：

```sh
sh toggle.sh enable     # 启用自启
sh toggle.sh disable    # 禁用自启
sh toggle.sh            # 显示用法
```

> 注意：改动 `enable` 后下次开机生效。

## 文件结构

```
paper_autostart/
├── module.prop    # Magisk 模块描述
├── service.sh     # 开机自启逻辑（boot_completed + see-through 等待 + 重试）
└── toggle.sh      # 启停开关脚本
```

## 工作原理

`service.sh`：

1. 最多等待 60 秒，直到 `sys.boot_completed=1`。
2. 再等待约 20 秒，等 see-through / 实验室设置结束，避免 Paper 被拦截。
3. 启动 `com.bridge.papertracker` 最多 5 次（每次间隔等待），检测到进程存在即停止。

## 许可证

MIT
