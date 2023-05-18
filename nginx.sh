#!/bin/bash
NGINX_VERSION="1.24.0"
NGINX_INSTALL_DIR="/usr/local/nginx"
apt update
apt install -y build-essential zlib1g-dev libpcre3-dev
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xzvf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}
./configure --prefix=${NGINX_INSTALL_DIR} --with-http_v2_module
make
make install
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
systemctl start nginx
systemctl enable nginx
echo "Nginx ${NGINX_VERSION} has been installed successfully."
cd ..
rm -rf nginx-${NGINX_VERSION} nginx-${NGINX_VERSION}.tar.gz
