#!/bin/bash
#========================================================
#   System Required: CentOS 7+ 
#   Description: 安装脚本
#   Github: https://github.com/
#========================================================
echo "安装依赖--------------------------------------------->"
yum install -y bc bind-utils compat-libcap1 compat-libstdc++-33 glibc-devel ksh libaio-devel libstdc++-devel net-tools nfs-utils psmisc smartmontools sysstat unzip xorg-x11-utils xorg-x11-xauthlibpcap-devel xz-devel
echo "下载------------------------------------------------->"
wget https://cn.upy.workers.dev/install/oracle/oracle-database-ee-19c-1.0-1.x86_64.rpm
wget https://cn.upy.workers.dev/install/oracle/oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm
# 如果不存在，启用备用下载链接
if [ ! -e "oracle-database-ee-19c-1.0-1.x86_64.rpm" ];then
	echo "oracle-database-ee-19c-1.0-1.x86_64.rpm下载失败------------------------------>"
else
	echo "存在------------------------------------------------->"
fi
if [ ! -e "oracle-database-ee-19c-1.0-1.x86_64.rpm" ];then
	echo "oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm下载失败------------------->"
else
	echo "存在------------------------------------------------->"
fi
echo "安装------------------------------------------------->"
rpm -ivh oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm
rpm -ivh oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm
rpm -ivh oracle-database-ee-19c-1.0-1.x86_64.rpm
echo "初始化------------------------------------------------->"
/etc/init.d/oracledb_ORCLCDB-19c configure
echo "配置系统环境变量------------------------------------------------->"
echo "export ORACLE_BASE=/opt/oracle" >> /etc/profile;
echo "export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1/" >> /etc/profile;
echo "export ORACLE_SID=ORCLCDB" >> /etc/profile;
echo "export PATH=$ORACLE_HOME/bin:$PATH:$HOME/.local/bin:$HOME/bin" >> /etc/profile;
echo "配置软件环境变量------------------------------------------------->"
echo "export PATH" >> /home/oracle/.bash_profile ;
echo "export ORACLE_BASE=/opt/oracle" >> /home/oracle/.bash_profile ;
echo "export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1" >> /home/oracle/.bash_profile ;
echo "export ORACLE_SID=ORCLCDB" >> /home/oracle/.bash_profile ;
echo "export PATH=$ORACLE_HOME/bin:$PATH:$HOME/.local/bin:$HOME/bin" >> /home/oracle/.bash_profile ;
echo "#LANG=C" >> /home/oracle/.bash_profile ;
echo "LANG=zh_CN.UTF-8; export LANG" >> /home/oracle/.bash_profile ;
echo "NLS_LANG="SIMPLIFIED CHINESE_CHINA.al32utf8"; export NLS_LANG" >> /home/oracle/.bash_profile ;
echo "刷新环境变量------------------------------------------------->"
source /etc/profile
source /home/oracle/.bash_profile
echo "切换oracle用户------------------------------------------------->"
su oracle
chmod 6751 $ORACLE_HOME/bin/oracle
lsnrctl status
lsnrctl start
#========================================================
#   进入数据库：sqlplus /nolog
#   使用sysdba角色登录sqlplus 默认 用户/密码连接:	conn /as sysdba
#   更改sys/system密码：password system;
#   启动数据库: SQL> startup	关闭数据库: SQL> shutdown
#========================================================
echo "安装完成-------------------------------------------->"
