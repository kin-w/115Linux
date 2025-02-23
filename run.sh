#!/bin/bash

# 使用 sed 命令在 /usr/local/115Cookie/worker.js 文件的开头插入 CID、SEID、UID 和 KID 的定义
sed -i "1s/^/const CID=\"${CID}\"\nconst SEID=\"${SEID}\"\nconst UID=\"${UID}\"\nconst KID=\"${KID}\"\n/" /usr/local/115Cookie/worker.js

# 检查 DISPLAY_WIDTH 是否为空，如果为空则设置默认值 1920
if [ -z "${DISPLAY_WIDTH}" ]; then
    DISPLAY_WIDTH=1920
fi

# 检查 DISPLAY_HEIGHT 是否为空，如果为空则设置默认值 1080
if [ -z "${DISPLAY_HEIGHT}" ]; then
    DISPLAY_HEIGHT=1080
fi

# 创建 ~/.vnc 目录，如果不存在则创建
mkdir -p "${HOME}/.vnc"

# 设置 VNC 密码文件的路径
export PASSWD_PATH="${HOME}/.vnc/passwd"

# 使用 vncpasswd 命令生成 VNC 密码文件
echo ${PASSWORD} | vncpasswd -f > "${PASSWD_PATH}"

# 设置 VNC 密码文件的权限为 0600（只有所有者可以读写）
chmod 0600 "${HOME}/.vnc/passwd"

# 启动 noVNC 代理，监听 1150 端口，连接到 localhost:6015
"${NO_VNC_HOME}"/utils/novnc_proxy --vnc localhost:6015 --listen 1150 &

# 创建 VNC 配置文件，设置显示几何尺寸
echo "geometry=${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}" > ~/.vnc/config

# 启动 VNC 服务器，监听 :115 端口
/usr/libexec/vncserver :115 &

# 等待 2 秒，确保 VNC 服务器启动完成
sleep 2;

# 启动 pcmanfm 桌面管理器
pcmanfm --desktop &

# 启动 115 浏览器
/usr/local/115Browser/115.sh

# 启动 tint2 任务栏
tint2