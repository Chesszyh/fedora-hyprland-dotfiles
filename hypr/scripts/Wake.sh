#!/bin/bash
# 强制开启 DPMS
hyprctl dispatch dpms on

# 刷新显示器
hyprctl reload

# 发送通知确认
notify-send "Screen Wake. Hello!!"