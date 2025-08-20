参考：`Keybinds.conf`

| 快捷键组合                      | 功能描述                                   |
|----------------------------------|--------------------------------------------|
| CTRL + ALT + Delete             | 退出 Hyprland                              |
| $mainMod + Q                    | 关闭活动窗口（非强制杀死）                 |
| $mainMod + SHIFT + Q            | 杀死活动进程（执行脚本）                   |
| CTRL + ALT + L                  | 锁屏（执行脚本）                           |
| CTRL + ALT + P                  | 电源菜单（执行脚本）                       |
| $mainMod + SHIFT + N            | 打开 swayNC 通知面板                       |
| $mainMod + SHIFT + E            | 打开 Kool_Quick_Settings 设置菜单           |
| $mainMod + CTRL + D             | 移除主窗口（Master布局）                   |
| $mainMod + I                    | 添加主窗口（Master布局）                   |
| $mainMod + J                    | 下一个窗口循环（Master布局）               |
| $mainMod + K                    | 上一个窗口循环（Master布局）               |
| $mainMod + CTRL + Return        | 与主窗口交换（Master布局）                 |
| $mainMod + SHIFT + I            | 切换分割（仅 Dwindle 布局）                |
| $mainMod + P                    | 切换伪窗口（仅 Dwindle 布局）              |
| $mainMod + M                    | 设置分割比例为 0.3                         |
| $mainMod + G                    | 切换窗口分组                               |
| $mainMod + CTRL + Tab           | 切换分组内活动窗口                         |
| ALT + Tab                       | 循环切换窗口                               |
| ALT + Tab                       | 将活动窗口置顶                             |
| 音量键（xf86audioraisevolume）   | 增加音量                                   |
| 音量键（xf86audiolowervolume）   | 降低音量                                   |
| 麦克风静音键（xf86AudioMicMute） | 麦克风静音                                 |
| 静音键（xf86audiomute）          | 切换静音                                   |
| 睡眠键（xf86Sleep）              | 挂起系统                                   |
| 飞行模式键（xf86Rfkill）         | 飞行模式                                   |
| 媒体播放/暂停键                  | 播放/暂停                                  |
| 媒体下一曲（xf86AudioNext）      | 下一曲                                     |
| 媒体上一曲（xf86AudioPrev）      | 上一曲                                     |
| 媒体停止（xf86audiostop）        | 停止播放                                   |
| $mainMod + Print                | 截屏（立即）                               |
| $mainMod + SHIFT + Print        | 截屏（区域）                               |
| $mainMod + CTRL + Print         | 截屏（延迟5秒）                            |
| $mainMod + CTRL + SHIFT + Print | 截屏（延迟10秒）                           |
| ALT + Print                     | 截屏（活动窗口）                           |
| $mainMod + SHIFT + S            | 截屏（swappy 工具）                        |
| $mainMod + SHIFT + 方向键       | 调整窗口大小                               |
| $mainMod + CTRL + 方向键        | 移动窗口                                   |
| $mainMod + ALT + 方向键         | 交换窗口                                   |
| $mainMod + 方向键               | 移动焦点                                   |
| $mainMod + Tab                  | 切换到下一个工作区                         |
| $mainMod + SHIFT + Tab          | 切换到上一个工作区                         |
| $mainMod + SHIFT + U            | 移动窗口到特殊工作区                       |
| $mainMod + U                    | 切换特殊工作区                             |
| $mainMod + [1-0]                | 切换到对应编号的工作区                     |
| $mainMod + SHIFT + [1-0]        | 移动窗口到对应编号的工作区并跟随           |
| $mainMod + CTRL + [1-0]         | 静默移动窗口到对应编号的工作区             |
| $mainMod + SHIFT + [            | 移动窗口到上一个工作区                     |
| $mainMod + SHIFT + ]            | 移动窗口到下一个工作区                     |
| $mainMod + CTRL + [             | 静默移动窗口到上一个工作区                 |
| $mainMod + CTRL + ]             | 静默移动窗口到下一个工作区                 |
| $mainMod + 鼠标滚轮下            | 切换到下一个工作区                         |
| $mainMod + 鼠标滚轮上            | 切换到上一个工作区                         |
| $mainMod + .                    | 切换到下一个工作区                         |
| $mainMod + ,                    | 切换到上一个工作区                         |
| $mainMod + 鼠标左键拖动          | 移动窗口                                   |
| $mainMod + 鼠标右键拖动          | 调整窗口大小                               |

> 说明：`$mainMod` 通常为 SUPER（Win）键，部分快捷键需配合 SHIFT、CTRL、ALT 使用。键码如 `code:10` 代表数字键 1，以此类推。