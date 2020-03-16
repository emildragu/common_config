#!/bin/bash
#Script Name	:setup_docker_centos_7.sh
#Description	:Sets up docker repo and installs docker
#Args           :[DOCKER_VERSION]
#Author       	:Emil Dragu
#Email         	:emil.dragu@gmail.com
#
#Usage:
# ./setup_docker_centos_7.sh
#   or
# ./setup_docker_centos_7.sh 19.03.8-3.el7 # to install version 19.03.8-3.el7 of docker 

DOCKER_VERSION=$1

sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

if [ "${DOCKER_VERSION}" == "" ]; then
    yum install -y docker-ce docker-ce-cli containerd.io
else
    yum info docker-ce-${DOCKER_VERSION} docker-ce-cli-${DOCKER_VERSION}
    if [ "$?" != "0" ]; then
	echo -e "\n\n\e[1;31mINSTALL FAILED, PLEASE FIND BELOW AVAILABLE VERSIONS!!!\e[0m\n\n"
        yum list docker-ce --showduplicates | sort -r
	echo -e "\n\n\e[1;31mINSTALL FAILED, PLEASE FIND ABOVE AVAILABLE VERSIONS!!!\e[0m\n\n"
        exit 1
    fi
    yum install -y docker-ce-${DOCKER_VERSION} docker-ce-cli-${DOCKER_VERSION} containerd.io
    # if install version failed list available versions
fi

echo -e "\n\n\e[1;32mDocker succesfully installed, starting service ...\e[0m\n\n"

systemctl start docker
systemctl status docker
