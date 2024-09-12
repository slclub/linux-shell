#!/bin/bash

#!/bin/bash
systemctl get-default
systemctl set-default multi-user.target
#vim /etc/inittab
#reboot
#

#xrandr
#xrandr -s 3

# setting centos screen display. it look like 1920*1000
#vi /boot/grub2/grub.cfg
#reboot
#ls
#xrandr
#vi /etc/profile
#ll /etc/sysconfig
#xrandr
#vi /boot/grub2/grub.cfg
#arch
#env
#uname -m
#uname -r
#ls
#history | grep grub
#vi /boot/grub2/grub.cfg
#xrandr
#vi /boot/grub2/grub.cfg

mkdir github.com

yum info git
# Disable firewalld
systemctl disable --now firewalld
systemctl disable --now dnsmasq
systemctl disable --now NetworkManager
setenforce 0
#vi /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disable/g' /etc/sysconfig/selinux
swapoff  -a && sysctl -w vm.swappiness=0

#date install

yum install ntp -y
ln -sf /usr/share/zoneinfo/Asia/Shanghai   /etc/localtime
echo 'Asia/Shanghai' > /etc/timezone
ntpdate time2.aliyun.com

#crontab -e
# 判断crontab文件夹是否存在
if [ ! -e /var/spool/cron/ ];then
  mkdir -p /var/spool/cron/
fi


# 添加定时任务：每天凌晨1点1分停止服务与1点2分启动服务
if [ `grep -v '^\s*#' /var/spool/cron/root |grep -c 'ntpdate'` -eq 0 ];then
  echo "*/5 * * * *  ntpdate time2.aliyun.com" >> /var/spool/cron/root
  #echo "* 1 1 * * sh $install_dir/stop.sh"  >> /var/spool/cron/root
  #echo "* 2 1 * * sh $install_dir/start.sh" >> /var/spool/cron/root
fi

# open interface
ulimit -SHn 65535
# install normal tools
yum -y install  wget net-tools lrzsz

echo "unset MAILCHECK" >> /etc/profile
source /etc/profile

# uninstall yum base repo.
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
ls


# update yum repo
ls /etc/yum.repos.d/
curl -o  /etc/yum.repos.d/Centos-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
ls /etc/yum.repos.d/
# install some depended software
yum install -y yum-utils device-mapper-persistent-data   lvm2
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

# search a new  centos7 kernel
yum --enablerepo="elrepo-kernel" list --showduplicates | sort -r | grep kernel-ml.x86_64


# install centos kernel.
yum --enablerepo="elrepo-kernel" list --showduplicates | sort -r | grep kernel-lt.x86_64
yum --enablerepo=elrepo-kernel install kernel-lt-devel kernel-lt -y

# set default kernel of centos7
grubby --default-kernel
awk -F\'  '$1=="menuentry " {print $2}'  /etc/grub2.cfg
grub2-set-default 0  && grub2-mkconfig -o /etc/grub2.cfg
grubby --args="user_namespace.enable=1" --update-kernel="$(grubby --default-kernel)"
grubby --default-kernel

# reboot

# It is too slow to connect sshd. so do not check the DNS server.
sed -i 's/UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS/UseDNS/g' /etc/ssh/sshd_config

