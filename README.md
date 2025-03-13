# Docker - 115浏览器Linux版_v35.9.0.2
![预览图](https://raw.githubusercontent.com/kin-w/115Linux/refs/heads/main/image.jpg)

### 镜像拉取命令（镜像加速，如不需要可删除 docker.1panel.live/）
```bash
docker pull docker.1panel.live/ikimi/115linux:latest
```
#### Docker-Compose.yaml
```yaml
services:
  115Linux:                         # 服务名称
    image: ikimi/115linux:latest    # 镜像加速（image: docker.1panel.live/ikimi/115linux:latest）
    container_name: 115Linux
    user: "0:0"                     # 以 root 用户身份运行
    volumes:
      - '/:/opt/Downloads'          # 传输目录(说明：/为系统根目录，/volume1为存储盘1的根目录)
      # - './115:/etc/115'          # 数据目录(说明：.为项目配置所在目录，需手动创建115文件夹)
    ports:
      - '1150:1150'                 # WEB访问端口后追加/vnc.html即noVNC页面访问
    environment:
      - PASSWORD=admin              # 密码(必须项，默认：admin)
      - DISPLAY_WIDTH=1920          # 显示宽度
      - DISPLAY_HEIGHT=1080         # 显示高度
      - TZ=Asia/Shanghai            # 时区
      - CID=                        # 添加CID（非必要，可删）
      - KID=                        # 添加KID（非必要，可删）
      - SEID=                       # 添加SEID（非必要，可删）
      - UID=                        # 添加UID（非必要，可删）
```

#### SSH运行命令(紧凑)
```shell
sudo docker run -d --name 115Linux --user 0:0 -v /:/opt/Downloads -p 1150:1150 -e PASSWORD=0 -e DISPLAY_WIDTH=1920 -e DISPLAY_HEIGHT=1080 -e TZ=Asia/Shanghai -e CID={CID} -e KID={KID} -e SEID={SEID} -e UID={UID} docker.1panel.live/ikimi/115linux:latest
```

#### SSH运行命令(多行)
```shell
sudo docker run -d \
  --name 115Linux \
  --user 0:0 \
  -v /:/opt/Downloads \
  -p 1150:1150 \
  -e PASSWORD=0 \
  -e DISPLAY_WIDTH=1920 \
  -e DISPLAY_HEIGHT=1080 \
  -e TZ=Asia/Shanghai \
  -e CID={CID} \
  -e KID={KID} \
  -e SEID={SEID} \
  -e UID={UID} \
  docker.1panel.live/ikimi/115linux:latest
```
> 在运行这条命令之前，你需要替换`{CID}`、`{KID}`、`{SEID}`和`{UID}`为实际的115网盘服务所需的认证信息或用户标识。当然，你也可以删除或保留。

### Web访问
通过以下链接访问 115 浏览器的 Web 界面：
[http://{IP}:1150/vnc.html](http://{IP}:1150/vnc.html)
|名称|描述|说明|
|:---------:|:---------:|:---------:|
|`{IP}`|地址|需要替换成你的IP|
|`1150`|端口|根据部署内容替换|
|`/vnc.html`|noVNC|用于noVNC页面访问|

### 环境变量

|名称|描述|必须|
|:---------:|:---------:|:---------:|
|PASSWORD|noVNC密码|◯|
|DISPLAY_WIDTH|窗口宽度|╳|
|DISPLAY_HEIGHT|窗口高度|╳|
|TZ|时区|╳|
|CID|Cookie|╳|
|SEID|Cookie|╳|
|UID|Cookie|╳|
|KID|Cookie|╳|

### 挂载目录

|路径|描述|必须|
|:---------:|:---------:|:---------:|
|/opt/Downloads|传输目录|╳|
|/etc/115|数据目录|╳|

### 端口占用
|端口|描述|必须|
|:---------:|:---------:|:---------:|
|1150|WEB端口|◯|
