#!/bin/bash
#========================================================
#   System Required: CentOS 7+ / Debian 8+ / Ubuntu 16+ /
#   Description: 安装脚本
#   Github: https://github.com/
#========================================================
echo "安装依赖--------------------------------------------->"
yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
echo "下载------------------------------------------------->"
wget https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tar.xz
# 如果不存在，启用备用下载链接
if [ ! -e "Python-3.6.2.tar.xz" ];then
	echo "下载失败，启用备用链接------------------------------------------------->"
	wget https://cn.upy.workers.dev/install/python3/Python-3.6.2.tar.xz
else
	echo "存在------------------------------------------------->"
fi
echo "安装------------------------------------------------->"
mkdir /usr/local/python3
tar -xvJf Python-3.6.2.tar.xz
cd Python-3.6.2
./configure --prefix=/usr/local/python3
make && make install
echo "软连接---------------------------------------------->"
ln -s /usr/local/python3/bin/python3 /usr/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
echo "安装完成-------------------------------------------->"