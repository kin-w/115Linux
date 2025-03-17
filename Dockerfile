# 基础镜像：使用最新的 Debian 系统
FROM debian:latest AS base
# 设置环境变量，确保使用中文 UTF-8 编码
ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8
# 更新软件包列表并安装必要的工具和库
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive \
    && apt install -y wget curl unzip locales locales-all \
    && locale-gen zh_CN.UTF-8 \
    && update-locale LANG=zh_CN.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# 桌面环境：在基础镜像上安装桌面管理工具
FROM base AS desktop
# 更新软件包列表并安装桌面环境相关工具
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive \
    # 安装文件管理器、任务栏、窗口管理器等
    && apt install -y pcmanfm tint2 openbox xauth xinit \
    && rm -rf /var/lib/apt/lists/*

# TigerVNC 服务器：在桌面环境上安装 TigerVNC
FROM desktop AS tigervnc
# 下载并解压 TigerVNC 服务器 https://sourceforge.net/projects/tigervnc/files/stable/1.15.0/tigervnc-1.15.0.x86_64.tar.gz
RUN wget -qO- https://github.com/kin-w/115Linux/releases/download/package/tigervnc-1.15.0.x86_64.tar.gz | tar xz --strip 1 -C /

# noVNC 代理：在 TigerVNC 环境上安装 noVNC 代理
FROM tigervnc AS novnc
# 设置 noVNC 安装目录
ENV NO_VNC_HOME=/usr/share/usr/local/share/noVNCdim
# 更新软件包列表并安装 Python 库
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y python3-numpy \
    # 创建 noVNC 和 websockify 的目录结构
    && mkdir -p "${NO_VNC_HOME}/utils/websockify" \
    # 下载并解压 noVNC 和 websockify https://github.com/novnc/noVNC/releases & https://github.com/novnc/websockify/releases
    && wget -qO- "https://github.com/novnc/noVNC/archive/v1.6.0.tar.gz" | tar xz --strip 1 -C "${NO_VNC_HOME}" \
    && wget -qO- "https://github.com/kin-w/115Linux/releases/download/package/websockify-0.13.0.tar.gz" | tar xz --strip 1 -C "${NO_VNC_HOME}/utils/websockify" \
    # 使 noVNC 代理可执行
    && chmod +x -v "${NO_VNC_HOME}/utils/novnc_proxy" \
    # 修改 noVNC 的 UI.js 以支持自动调整大小
    && sed -i '1s/^/if(localStorage.getItem("resize") == null){localStorage.setItem("resize","remote");}\n/' "${NO_VNC_HOME}/app/ui.js" \
    && rm -rf /var/lib/apt/lists/*

# 115 浏览器：在 noVNC 环境上安装 115 浏览器
FROM novnc AS oneonefive
# 设置环境变量
ENV \
    XDG_CONFIG_HOME=/tmp \
    XDG_CACHE_HOME=/tmp \
    HOME=/opt \
    DISPLAY=:115 \
    LD_LIBRARY_PATH=/usr/local/115Browser:\$LD_LIBRARY_PATH
# 更新软件包列表并安装必要的库
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive \
    && apt install -y libnss3 libasound2 libgbm1 \
    # 下载并安装 jq 工具 jq-1.7.1 https://github.com/jqlang/jq/releases
    && wget -q --no-check-certificate -c https://github.com/kin-w/115Linux/releases/download/package/jq-linux-amd64 \
    && chmod +x jq-linux-amd64 \
    && mv jq-linux-amd64 /usr/bin/jq \
    # 获取 115 浏览器的最新版本号
    # && export VERSION=`curl -s https://appversion.115.com/1/web/1.0/api/getMultiVer | jq '.data["Linux-115chrome"].version_code'  | tr -d '"'` \
    # 下载并安装 115 浏览器
    # && wget -q --no-check-certificate -c "https://down.115.com/client/115pc/lin/115br_v${VERSION}.deb" \
    && wget -q --no-check-certificate -c "https://down.115.com/client/115pc/lin/115br_v35.8.0.1.deb" \
    # && apt install "./115br_v${VERSION}.deb"  \
    && apt install "./115br_v35.8.0.1.deb"  \
    # && rm "115br_v${VERSION}.deb" \
    && rm "115br_v35.8.0.1.deb" \
    # 下载并解压 115Cookie 扩展
    && wget -q --no-check-certificate -c https://github.com/kin-w/115Cookie/archive/refs/heads/master.zip \
    && unzip -j master.zip -d /usr/local/115Cookie/ \
    && rm master.zip \
    # 创建必要的目录并设置权限
    && mkdir -p /opt/Desktop \
    && mkdir -p /opt/Downloads \
    && chmod 777 -R /opt/Downloads \
    && cp /usr/share/applications/115Browser.desktop /opt/Desktop \
    && cp /usr/share/applications/pcmanfm.desktop /opt/Desktop \
    && chmod 777 -R /opt \
    && mkdir -p /etc/115 \
    && chmod 777 -R /etc/115 \
    # 创建 115 浏览器启动脚本
    && echo "cd /usr/local/115Browser" > /usr/local/115Browser/115.sh \
    && echo "/usr/local/115Browser/115Browser \
    --test-type \
    --disable-backgrounding-occluded-windows \
    --user-data-dir=/etc/115 \
    --disable-cache \
    --load-extension=/usr/local/115Cookie \
    --disable-wav-audio \
    --disable-logging \
    --disable-notifications \
    --no-default-browser-check \
    --disable-background-networking \
    --enable-features=ParallelDownloading \
    --start-maximized \
    --no-sandbox \
    --disable-vulkan \
    --disable-gpu \
    --ignore-certificate-errors \
    --disable-bundled-plugins \
    --disable-dev-shm-usage \
    --reduce-user-agent-sniffing \
    --no-first-run \
    --disable-breakpad \
    --disable-gpu-process-crash-limit \
    --enable-low-res-tiling \
    --disable-heap-profiling \
    --disable-features=IsolateOrigins,site-per-process \
    --disable-smooth-scrolling \
    --lang=zh-CN \
    --disable-software-rasterizer \
    >/tmp/115Browser.log 2>&1 &" >> /usr/local/115Browser/115.sh \
    && rm -rf /var/lib/apt/lists/*

# 最终镜像：暴露 1150 端口并复制启动脚本
FROM oneonefive
EXPOSE 1150
COPY run.sh /opt/run.sh
CMD ["bash","/opt/run.sh"]
