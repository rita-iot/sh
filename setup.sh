#!/bin/bash
# 小白写法，大神绕道
#======================================================
#   System Required: CentOS 7+ 其他版本未测试
#   Description: 服务器环境安装一键脚本
#   Github: https://gitee.com/m67440/shell
#======================================================
# 颜色
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# install jdk1.8
install_jdk(){
	# 设置jdk软件目录
	jdk_home="/usr/local/java"
	soft_dir="/opt/jdk"
  	# JAVA_HOME=/usr/local/java/jdk1.8.0_144
	echo "创建jdk软件包目录"$soft_dir;
	mkdir $soft_dir
	########################################################
	#############       安装 jdk1.8.0_144     ##############
	########################################################
	echo "执行下载安装jdk------------------------------------------>";
	cd $soft_dir;
	wget "https://cn.upus.tools/install/jdk/jdk-8u144-linux-x64.tar.gz";
	echo "开始解压------------------------------------------>";
	mkdir $jdk_home
	tar -zxvf jdk-8u144-linux-x64.tar.gz -C $jdk_home
	cd $jdk_home
	#配置环境变量
	echo "开始配置java环境变量！------------------------------------------>"
	echo "export JAVA_HOME=/usr/local/java/jdk1.8.0_144" >> /etc/profile;
	# \转义
	echo "export CLASSPATH=\$JAVA_HOME/lib/rt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile;
	echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile;
	# 刷新环境变量
	source /etc/profile
	echo "安装完毕,下面进行测试!------------------------------------------>"
	java -version
	# 显示菜单栏
	show_menu
}
install_nginx(){
	soft_dir="/opt/nginx"
	echo "重置软件包目录"$soft_dir;
	sleep 3s;
	if [ ! -d "$soft_dir" ]; then
	   mkdir $soft_dir
	fi

	########################################################
	#############       安装 nginx 1.18.0     ##############
	########################################################
	echo "执行安装nginx,以及https模块";
	yum install -y  make zlib zlib-devel gcc-c++ libtool openssl openssl-devel;
	yum install -y gcc-c++ pcre-devel openssl-devel;
	cd $soft_dir;
	echo "下载nginx 1.18.0";
	wget "http://nginx.org/download/nginx-1.18.0.tar.gz";
	echo "开始解压...";

	tar -zvxf nginx-1.18.0.tar.gz;
	cd $soft_dir'/nginx-1.18.0';
	./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module
	make && make install
	groupadd nginx
	useradd nginx -g nginx -M -s /sbin/nologin
	/usr/local/nginx/sbin/nginx

	echo "配置nginx开机启动"
	echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.d/rc.local
	chmod +x /etc/rc.local
	echo "开启防火墙80端口"
	firewall-cmd --zone=public --add-port=80/tcp --permanent
	firewall-cmd --zone=public --add-port=80/udp --permanent
	echo "开启防火墙443端口"
	firewall-cmd --zone=public --add-port=443/tcp --permanent
	firewall-cmd --zone=public --add-port=443/udp --permanent
	echo "重启防火墙-------------------------------------------------------------->"
	firewall-cmd --reload
	# 显示菜单栏
	show_menu
}
install_node(){
	# 软件下载目录
	soft_dir="/opt/node"

	echo "重置软件包目录"$soft_dir;
	# rm -rf $soft_dir;
	sleep 3s;
	if [ ! -d "$soft_dir" ]; then
	   mkdir $soft_dir
	fi

	#############################################################
	#############         安装 node 12.18.3        ##############
	#############################################################

	echo "进入软件目录下载node";
	cd $soft_dir;
	node_home=/usr/local/node;
	rm -rf $node_home;
	sleep 1s;
	wget "https://mirrors.ustc.edu.cn/node/v12.18.3/node-v12.18.3-linux-x64.tar.xz";
	echo "开始解压...";
	mkdir $node_home
	xz -d node-v12.18.3-linux-x64.tar.xz;
	tar -vxf node-v12.18.3-linux-x64.tar
	mv ./node-v12.18.3-linux-x64/* $node_home;
	echo "开始设置node,npm,cnpm环境变量";
	sleep 3s;

	echo "export NODE_HOME="$node_home >> /etc/profile;
	echo "export PATH=\$NODE_HOME/bin:\$PATH" >> /etc/profile;
	echo "生效环境变量";
	sleep 1s;
	source /etc/profile;
	echo "查看node版本-------------------------------------------------------------->";
	node -v
	echo "查看npm版本-------------------------------------------------------------->";
	npm -v
	echo "安装cnpm";
	npm install cnpm -g --registry=https://registry.npm.taobao.org
	echo "查看cnpm版本-------------------------------------------------------------->";
	cnpm -v

	echo "请手动执行:source /etc/profile"

	# 显示菜单栏
	show_menu
}

install_mysql(){
	# mysql安装目录
	mysql_home=/usr/local/mysql

	soft_dir="/opt/mysql"

	echo "创建mysql软件包目录"$soft_dir;
	mkdir $soft_dir

	########################################################
	#############       安装 mysql 5.7.31     ##############
	########################################################
	# mysql数据存放目录
	data_dir=$mysql_home'/data'


	echo "添加mysql用户和用户组------------------------------------------>";
	groupadd mysql
	useradd mysql -g mysql -M -s /sbin/nologin

	echo "重置MySQL数据目录和安装目录,并赋予mysql权限";
	rm -rf $data_dir;
	rm -rf $mysql_home;
	sleep 3s;
	mkdir -p $data_dir;
	mkdir -p $mysql_home;
	cd $data_dir
	chown -R mysql .
	chgrp -R mysql .
	cd $mysql_home
	chown -R mysql .
	chgrp -R mysql .

	echo "执行下载安装mysql------------------------------------------>";
	cd $soft_dir;
	wget "https://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.7/mysql-5.7.31-linux-glibc2.12-x86_64.tar.gz";
	echo "开始解压------------------------------------------>";

	tar -zvxf mysql-5.7.31-linux-glibc2.12-x86_64.tar.gz;
	cd $soft_dir'/';

	mv ./mysql-5.7.31-linux-glibc2.12-x86_64/* $mysql_home;
	cd $mysql_home'/bin/'

	echo "初始化mysql数据库------------------------------------------>";
	./mysqld --initialize --basedir=$mysql_home --datadir=$data_dir --user=mysql
	sleep 3s;

	cp $mysql_home'/support-files/mysql.server' /etc/init.d/mysqld

	sleep 2s;

	echo "配置MySQL环境变量------------------------------------------>"

	echo 'export PATH='$mysql_home/bin':$PATH' >> /etc/profile
	source /etc/profile
	ln -s /usr/local/mysql/bin/* /usr/bin

	echo "赋予权限启动mysql------------------------------------------>"
	chmod 777 /etc/my.cnf
	/etc/init.d/mysqld start

	echo "使用如下命令修改mysql默认密码------------------------------>"
	echo " set password=password('123456'); "

	echo "本机连接mysql------------------------------------------>"
	# 显示菜单栏
	show_menu
}

install_maven(){
	########################################################
	#############         安装 maven 3.6.3    ##############
	########################################################
	# 软件下载目录
	soft_dir="/opt/maven"
	echo "重置软件包目录"$soft_dir;
	# rm -rf $soft_dir;
	sleep 3s;
	# 判断文件夹是否存在
	if [ ! -d "$soft_dir" ]; then
	    	mkdir $soft_dir
	    	echo "进入软件目录下载maven";
		cd $soft_dir;
		maven_home=/usr/local/maven;
		sleep 1s;
		wget "https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz";
		echo "开始解压...";

		tar -zvxf apache-maven-3.6.3-bin.tar.gz;
		mv ./apache-maven-3.6.3 $maven_home;
		echo "开始设置maven环境变量-------------------------------------------------------------->";
		sleep 3s;

		echo "export MAVEN_HOME="$maven_home >> /etc/profile;
		echo "export PATH=\$MAVEN_HOME/bin:\$PATH" >> /etc/profile;
		echo "生效环境变量-------------------------------------------------------------->";
		sleep 1s;
		source /etc/profile;
		echo "查看maven版本-------------------------------------------------------------->";
		mvn -v
		# 显示菜单栏
		show_menu
	else 
		# 存在证明下载过 ，直接解压
		cd $soft_dir;
		tar -zvxf apache-maven-3.6.3-bin.tar.gz;
		mv ./apache-maven-3.6.3 $maven_home;
		echo "开始设置maven环境变量-------------------------------------------------------------->";
		sleep 3s;

		echo "export MAVEN_HOME="$maven_home >> /etc/profile;
		echo "export PATH=\$MAVEN_HOME/bin:\$PATH" >> /etc/profile;
		echo "生效环境变量-------------------------------------------------------------->";
		sleep 1s;
		source /etc/profile;
		echo "查看maven版本-------------------------------------------------------------->";
		mvn -v
		# 显示菜单栏
		show_menu
	fi
}

# 调用菜单显示方法
show_menu() {
    echo -e "
    ${green}N.${plain}  服务器环境安装一键脚本v1.0
    --- https://gitee.com/upy/shell ---
    ${green}0.${plain}  退出脚本
    ————————————————-
    ${green}1.${plain}  安装jdk 1.8.0_144(先安装)
    ${green}2.${plain}  安装node 12.18.3
    ${green}3.${plain}  安装mysql 5.7.31
    ${green}4.${plain}  安装nginx 1.18.0
    ${green}5.${plain}  安装maven 3.6.3
    ${green}6.${plain}  安装...
    --- https://gitee.com/upy/shell ---
    "
    echo && read -p "请输入选择 [0-12]: " num

    case "${num}" in
    0)
        exit 0
        ;;
    1)
        install_jdk
        ;;
    2)
        install_node
        ;;
    3)
        install_mysql
        ;;
    4)
        install_nginx
        ;;
    5)
        install_maven
        ;;
    6)
        install_
        ;;
    *)
        echo -e "${red}请输入正确的数字 [0-12]${plain}"
        ;;
    esac
}
# 调用菜单显示
show_menu
