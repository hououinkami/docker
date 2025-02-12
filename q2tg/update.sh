#!/bin/bash

echo "请选择要使用的版本:"
echo "1) icqq"
echo "2) napcat"

# 读取用户输入
read -p "请选择: " choice

# 根据输入执行相应命令
case $choice in
    1)
        echo "使用icqq版本..."
        cd ~/Docker/q2tg
        curl -o customize.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/q2tg/customize.sh
        sh customize.sh
        curl -o docker-compose.yaml https://raw.githubusercontent.com/hououinkami/Docker/main/q2tg-icqq.yaml
        docker compose pull
        docker-compose up -d --remove-orphans
        docker image prune --force
        ;;
    2)
        echo "使用napcat版本..."
        cd ~/Docker/q2tg
        curl -o customize.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/q2tg/customize.sh
        sh customize.sh
        curl -o docker-compose.yaml https://raw.githubusercontent.com/hououinkami/Docker/main/q2tg-napcat.yaml
        docker compose pull
        docker-compose up -d --remove-orphans
        docker image prune --force
        ;;
    *)
        echo "错误：无效选项，请输入1或2！"
        exit 1
        ;;
esac
