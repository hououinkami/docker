#!/bin/bash

echo "请选择要进行的操作:"
echo "1)更新"
echo "2)重启容器"
echo "3)查看日志"

read -p "请选择: " choice

case $choice in
    1)
        ;;
    2)
        echo "重启wx2tg容器..."
        docker restart wx2tg
        exit 0
        ;;
    3)
        echo "查看wx2tg容器日志..."
        docker logs -f wx2tg
        exit 0
        ;;
    *)
        echo "错误：无效选项，请输入1或2！"
        exit 1
        ;;
esac

echo "请选择要使用的镜像:"
echo "1) 正式版"
echo "2) 测试版"

read -p "请选择: " choice

case $choice in
    1)
        echo "使用finalpi的正式版镜像..."
        export IMAGE_NAME=finalpi/wechat2tg-pad:latest
        ;;
    2)
        echo "使用自编译的测试版镜像..."
        export IMAGE_NAME=hououinkami/wechat2tg-pad:latest
        ;;
    *)
        echo "错误：无效选项，请输入1或2！"
        exit 1
        ;;
esac

echo "请选择操作:"
echo "1) 仅更新wechat2tg"
echo "2) 仅更新gewechat"
echo "3) 更新wechat2tg与gewechat"

read -p "请选择: " choice

case $choice in
    1)
        echo "正在更新wechat2tg..."
        cd ~/Docker
        mkdir -p wx2tg
        cd wx2tg
        ln -sf ../.env .env
        curl -o customize.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/customize.sh
        sh customize.sh
        curl -o docker-compose.yaml https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg-pad.yaml
        docker compose pull wechat2tg
        docker-compose up -d --no-deps --remove-orphans wechat2tg
        docker image prune --force
        ;;
    2)
        echo "正在更新gewechat..."
        cd ~/Docker
        mkdir -p wx2tg
        cd wx2tg
        ln -sf ../.env .env
        curl -o docker-compose.yaml https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg-pad.yaml
        docker compose pull gewechat
        docker-compose up -d --no-deps --remove-orphans gewechat
        docker image prune --force
        ;;
    3)
        echo "正在更新..."
        cd ~/Docker
        mkdir -p wx2tg
        cd wx2tg
        ln -sf ../.env .env
        curl -o customize.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/customize.sh
        sh customize.sh
        curl -o docker-compose.yaml https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg-pad.yaml
        docker compose pull
        docker-compose up -d --remove-orphans
        docker image prune --force
        ;;
    *)
        echo "错误：无效选项，请输入1或2！"
        exit 1
        ;;
esac
