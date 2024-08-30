#!/bin/bash

yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y  docker-ce-20.10.24 docker-ce-cli-20.10.24 containerd.io
systemctl enable docker
systemctl restart docker

# 下载的太慢
# download too slow
#curl -L https://get.daocloud.io/docker/compose/releases/download/2.25.5/docker-compose-`uname -s`-`uname -m`  > /usr/local/bin/docker-compose

