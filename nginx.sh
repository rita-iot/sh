#!/bin/bash

# 定义变量
NGINX_VERSION="1.24.0"   # 指定的Nginx版本号
NGINX_INSTALL_DIR="/usr/local/nginx"   # Nginx安装目录

# 安装编译依赖项
apt update
apt install -y build-essential zlib1g-dev libpcre3-dev

# 下载Nginx源代码并解压
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xzvf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}

# 配置编译参数，添加HTTP/2模块
./configure --prefix=${NGINX_INSTALL_DIR} --with-http_v2_module

# 编译并安装Nginx
make
make install

# 配置Nginx服务
cat > /etc/systemd/system/nginx.service <<EOF
[Unit]
Description=Nginx HTTP server
After=network.target

[Service]
Type=forking
ExecStart=${NGINX_INSTALL_DIR}/sbin/nginx
ExecReload=${NGINX_INSTALL_DIR}/sbin/nginx -s reload
ExecStop=${NGINX_INSTALL_DIR}/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# 启动Nginx服务
systemctl start nginx

# 设置开机自启动
systemctl enable nginx

# 显示安装完成信息
echo "Nginx ${NGINX_VERSION} has been installed successfully."

# 清理临时文件
cd ..
rm -rf nginx-${NGINX_VERSION} nginx-${NGINX_VERSION}.tar.gz