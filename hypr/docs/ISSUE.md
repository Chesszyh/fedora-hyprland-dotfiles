# ISSUE

## 假死问题

与最开始一样，锁屏时间长了以后就会导致假死，无法再次唤醒。

## 中文打字时有时无法显示文本候选框

可能是出界了？

## 主屏幕字体太小

调整`monitors.conf`参数：

```ini
# Monitors~
# monitor=,preferred,auto,1
monitor=eDP-1,2560x1600@240,0x0,1.3333333 # from 1 to 1.3333, etc
monitor=HDMI-A-1,1920x1080@60,auto,1
```

## Swappy启动报错：桌面文件未指定exec字段。

检查Swappy的`.desktop`文件(~/.local/share/applications/swappy.desktop)：

```ini
Exec=sh -c "if [ -n \"\\$*\" ]; then exec swappy -f \"\\$@\"; else grim -g \"\\$(slurp)\" - | swappy -f -; fi" placeholder %F
```

placeholder 是多余的，应该去掉。`%F` 已经是桌面文件传递参数的标准方式，不需要 shell 复杂判断。改为：

```
Exec=swappy -f %F
```

即可。

## F1,F2等键不好使

其实是没按`Fn`键的原因，或者按成Win了。`Keybinds.conf`是正确的。