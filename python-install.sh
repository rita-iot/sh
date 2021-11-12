#!/bin/bash
#========================================================
#   System Required: CentOS 7+ / Debian 8+ / Ubuntu 16+ /
#   Arch 未测试
#   Description: 哪吒监控安装脚本
#   Github: https://github.com/
#========================================================
echo "安装依赖--------------------------------------------->"
yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
if [ -f "Python-3.6.2.tar.xz"];then
	echo "下载------------------------------------------------->"
	wget https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tar.xz
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