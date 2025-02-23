#!/bin/bash

# ʹ�� sed ������ /usr/local/115Cookie/worker.js �ļ��Ŀ�ͷ���� CID��SEID��UID �� KID �Ķ���
sed -i "1s/^/const CID=\"${CID}\"\nconst SEID=\"${SEID}\"\nconst UID=\"${UID}\"\nconst KID=\"${KID}\"\n/" /usr/local/115Cookie/worker.js

# ��� DISPLAY_WIDTH �Ƿ�Ϊ�գ����Ϊ��������Ĭ��ֵ 1920
if [ -z "${DISPLAY_WIDTH}" ]; then
    DISPLAY_WIDTH=1920
fi

# ��� DISPLAY_HEIGHT �Ƿ�Ϊ�գ����Ϊ��������Ĭ��ֵ 1080
if [ -z "${DISPLAY_HEIGHT}" ]; then
    DISPLAY_HEIGHT=1080
fi

# ���� ~/.vnc Ŀ¼������������򴴽�
mkdir -p "${HOME}/.vnc"

# ���� VNC �����ļ���·��
export PASSWD_PATH="${HOME}/.vnc/passwd"

# ʹ�� vncpasswd �������� VNC �����ļ�
echo ${PASSWORD} | vncpasswd -f > "${PASSWD_PATH}"

# ���� VNC �����ļ���Ȩ��Ϊ 0600��ֻ�������߿��Զ�д��
chmod 0600 "${HOME}/.vnc/passwd"

# ���� noVNC �������� 1150 �˿ڣ����ӵ� localhost:6015
"${NO_VNC_HOME}"/utils/novnc_proxy --vnc localhost:6015 --listen 1150 &

# ���� VNC �����ļ���������ʾ���γߴ�
echo "geometry=${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}" > ~/.vnc/config

# ���� VNC ������������ :115 �˿�
/usr/libexec/vncserver :115 &

# �ȴ� 2 �룬ȷ�� VNC �������������
sleep 2;

# ���� pcmanfm ���������
pcmanfm --desktop &

# ���� 115 �����
/usr/local/115Browser/115.sh

# ���� tint2 ������
tint2