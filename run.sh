#!/bin/bash

# 在 worker.js 文件的第一行插入 CID、SEID、UID 和 KID 的环境变量值
sed -i "1s/^/const CID=\"${CID}\"\nconst SEID=\"${SEID}\"\nconst UID=\"${UID}\"\nconst KID=\"${KID}\"\n/" /usr/local/115Cookie/worker.js

# 如果 DISPLAY_WIDTH 环境变量未设置，则默认设置为 1920
if [ -z "${DISPLAY_WIDTH}" ]; then
    DISPLAY_WIDTH=1920
fi

# 如果 DISPLAY_HEIGHT 环境变量未设置，则默认设置为 1080
if [ -z "${DISPLAY_HEIGHT}" ]; then
    DISPLAY_HEIGHT=1080
fi

# 创建 .vnc 目录
mkdir -p "${HOME}/.vnc"
# 设置 VNC 密码文件的路径
export PASSWD_PATH="${HOME}/.vnc/passwd"
# 将环境变量 PASSWORD 的值写入 VNC 密码文件
echo ${PASSWORD} | vncpasswd -f > "${PASSWD_PATH}"
# 设置 VNC 密码文件的权限为仅用户可读写
chmod 0600 "${HOME}/.vnc/passwd"

# 启动 noVNC 代理，监听 1150 端口，并连接到本地的 VNC 服务（端口 6015）
"${NO_VNC_HOME}"/utils/novnc_proxy --vnc localhost:6015 --listen 1150 &
# 设置 VNC 显示的分辨率
echo "geometry=${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}" > ~/.vnc/config
# 启动 VNC 服务器，监听 115 号显示端口
/usr/libexec/vncserver :115 &
# 等待 2 秒，确保 VNC 服务器启动完成
sleep 2;
# 启动 PCManFM 文件管理器作为桌面
pcmanfm --desktop &
# 启动 115 浏览器
/usr/local/115Browser/115.sh
# 启动 tint2 任务栏，设置 G_SLICE 环境变量以避免内存碎片问题
G_SLICE=always-malloc tint2
