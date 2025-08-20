# Fedora Hyprland Dotfiles

这是一套为 Fedora Hyprland 定制的综合性配置文件，旨在提供一个功能强大、美观且高度可定制的桌面环境。

此配置的核心设计思想是将基础配置与用户个人配置分离，使用户可以在不修改核心文件的情况下，轻松地进行个性化定制。所有用户相关的修改都应在 `UserConfigs/` 目录下完成，这样在未来更新基础配置时，可以最大程度地避免冲突。

## ✨ 主要功能

- **高度模块化**：配置被拆分为多个文件，结构清晰，易于管理。
- **用户配置分离**：个人定制（快捷键、启动项等）集中在 `UserConfigs` 目录，方便维护。
- **强大的脚本支持**：通过大量脚本实现各种便捷功能，如亮度/音量调节、截图、主题切换等。
- **动态壁纸与主题**：使用 `swww` 和 `wallust` 实现壁纸切换和基于壁纸的动态色彩主题。
- **完善的电源管理**：通过 `hypridle` 和 `hyprlock` 配置屏幕锁定和挂起行为。
- **可定制的快捷键**：预设了大量实用的快捷键，并可在 `UserConfigs/UserKeybinds.conf` 中轻松覆盖或扩展。
- **显示器配置文件**：通过 `Monitor_Profiles/` 和 `monitors.conf` 轻松管理不同的显示器布局。

---

## 📂 文件结构说明

以下是关键文件和目录的结构说明：

| 文件/目录 | 说明 |
| :--- | :--- |
| `hyprland.conf` | **主配置文件**。这是 Hyprland 的入口点，它负责 `source` (加载) 所有其他的配置文件。 |
| `hypridle.conf` | **空闲配置文件**。定义了系统在无人操作时触发的事件，如超时后锁定屏幕或关闭显示器。 |
| `hyprlock.conf` | **锁屏样式文件**。定义了 `hyprlock` 锁屏界面的外观和元素。 |
| `monitors.conf` | **显示器配置文件**。用于定义显示器的分辨率、刷新率、位置和工作区分配。 |
| `workspaces.conf` | **工作区规则**。用于将特定应用程序默认分配到指定的工作区。 |
| `animations/` | 存放各种预设的窗口动画效果配置文件。 |
| `configs/` | 存放一些基础的、不常变动的配置片段，如默认快捷键。 |
| `scripts/` | **核心功能脚本目录**。包含了绝大部分功能的实现脚本。 |
| `UserConfigs/` | **用户配置核心目录**。所有个人定制化内容都在这里修改。 |
| `UserScripts/` | **用户脚本目录**。用于存放用户自己的定制脚本。 |
| `wallust/` | 存放 `wallust` 生成的色彩主题文件。 |

---

## 🛠️ 如何定制

为了保持配置的整洁和易于更新，请将你所有的个人修改集中在 `UserConfigs/` 目录中。

- **修改快捷键**: 编辑 `UserConfigs/UserKeybinds.conf`。
- **添加开机自启应用**: 编辑 `UserConfigs/Startup_Apps.conf`。
- **修改窗口规则**: 编辑 `UserConfigs/WindowRules.conf`。
- **修改动画效果**: 编辑 `UserConfigs/UserAnimations.conf`。
- **修改其他 Hyprland 设置**: 编辑 `UserConfigs/UserSettings.conf`。
- **设置环境变量**: 编辑 `UserConfigs/ENVariables.conf`。

---

## ⌨️ 主要快捷键

`$mainMod` 默认为 `SUPER` (Win) 键。

### 窗口与工作区管理

| 快捷键 | 功能 |
| :--- | :--- |
| `SUPER + Q` | 关闭当前窗口 |
| `SUPER + M` | 全屏当前窗口 |
| `SUPER + F` | 切换浮动/平铺模式 |
| `SUPER + P` | 切换伪平铺 (Pseudo-tiling) |
| `SUPER + J` | 切换窗口分割布局 (Dwindle/Master) |
| `SUPER + G` | 切换分组/标签模式 (Group/Tab) |
| `SUPER + [0-9]` | 切换到对应工作区 |
| `SUPER + SHIFT + [0-9]` | 将当前窗口移动到对应工作区 |
| `SUPER + S` | 切换特殊工作区 (用于下拉式终端等) |
| `SUPER + SHIFT + S` | 将当前窗口移动到特殊工作区 |
| `SUPER + 鼠标左键拖动` | 移动窗口 |
| `SUPER + 鼠标右键拖动` | 缩放窗口 |
| `SUPER + 滚轮` | 在工作区之间切换 |

### 应用程序启动

| 快捷键 | 功能 |
| :--- | :--- |
| `SUPER + T` | 打开终端 (kitty) |
| `SUPER + E` | 打开文件管理器 (thunar) |
| `SUPER + D` | 打开应用启动器 (rofi) |
| `SUPER + R` | 打开可运行命令的 Rofi |
| `SUPER + W` | 打开浏览器 (brave) |
| `SUPER + C` | 打开 VS Code |

### 功能脚本

| 快捷键 | 功能 |
| :--- | :--- |
| `SUPER + L` | 锁定屏幕 |
| `SUPER + SHIFT + L` | 注销菜单 (wlogout) |
| `SUPER + SHIFT + B` | 切换 Waybar 的显示/隐藏 |
| `SUPER + SHIFT + N` | 切换勿扰模式 |
| `SUPER + SHIFT + R` | 重新加载 Waybar |
| `SUPER + V` | 显示剪贴板历史 (rofi) |
| `SUPER + X` | 打开电源菜单 (wlogout) |
| `PrintScreen` | 截图 (全屏) |
| `SHIFT + PrintScreen` | 截图 (选区) |
| `SUPER + K` | 显示快捷键提示 |

### 音量与亮度

| 快捷键 | 功能 |
| :--- | :--- |
| `音量增/减/静音键` | 控制系统音量 |
| `亮度增/减键` | 控制屏幕亮度 |

---

## 📜 核心脚本说明

`scripts/` 目录下的脚本是本套配置的核心，提供了丰富的功能。

| 脚本名 | 功能 |
| :--- | :--- |
| `AirplaneMode.sh` | 切换飞行模式。 |
| `Animations.sh` | 切换不同的窗口动画效果。 |
| `Battery.sh` | 获取电池状态，用于 Waybar 显示。 |
| `Brightness.sh` | 使用 `brightnessctl` 调节屏幕亮度。 |
| `ChangeBlur.sh` | 调整窗口背景模糊度。 |
| `ClipManager.sh` | 启动 `cliphist` 的 Rofi 界面，管理剪贴板历史。 |
| `DarkLight.sh` | 切换系统深色/浅色主题。 |
| `GameMode.sh` | 切换游戏模式（关闭动画、窗口阴影等以提升性能）。 |
| `KeyHints.sh` | 显示一个包含所有主要快捷键的提示窗口。 |
| `KillActiveProcess.sh` | 强制杀死当前聚焦的窗口进程。 |
| `LockScreen.sh` | 执行锁屏命令。 |
| `MediaCtrl.sh` | 控制媒体播放（播放/暂停/下一首/上一首）。 |
| `RofiSearch.sh` | 使用 Rofi 在网络上进行搜索。 |
| `ScreenShot.sh` | 截图脚本，支持全屏、窗口和选区截图。 |
| `SwitchKeyboardLayout.sh`| 切换键盘布局。 |
| `Volume.sh` | 使用 `pamixer` 控制音量。 |
| `WallustSwww.sh` | 使用 `swww` 和 `wallust` 更换壁纸并应用新的色彩主题。 |
| `WaybarLayout.sh` | 切换 Waybar 的布局。 |
| `WaybarStyles.sh` | 切换 Waybar 的样式。 |
| `Wlogout.sh` | 启动 `wlogout` 电源菜单。 |

---

## 💡 依赖项

为了使所有功能正常工作，请确保安装了以下主要依赖项：

- **核心**: `hyprland`, `hyprlock`, `hypridle`, `waybar`, `rofi`, `kitty`, `thunar`
- **系统工具**: `brightnessctl`, `pamixer`, `playerctl`, `cliphist`, `polkit-kde`
- **截图**: `grim`, `slurp`, `swappy`
- **主题与外观**: `swww`, `wallust`, `nwg-look`, `wlogout`, `noto-fonts-emoji`
- **其他**: `cava` (用于 Waybar 音频可视化)