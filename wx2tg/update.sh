#!/bin/bash

# 定义函数
updateContainer() {
    if [ "$3" = "true" ]; then
        rm -rf ./src && cp -rf ../wechat2tg/src ./
        curl -o localize.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/localize.sh
        curl -o modify.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/modify.sh
        source ./localize.sh
        source ./modify.sh
        awk_script=''
        for_each_key
        cd src
        adaptFile
    else
        rm -rf ./src
    fi
    curl -o docker-compose.yaml https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg-pad.yaml
    if [ "$2" = "false" ]; then
        pull="missing"
    else
        pull="always"
    fi
    docker compose up -d --no-deps --remove-orphans --pull "$pull" "$1"
    docker image prune --force
}

# 更新脚本
echo "请选择要进行的操作:"
echo "u)更新wx2tg"
echo "a)更新全部"
echo "t)测试wx2tg"
echo "r)重启wx2tg容器并查看容器日志"
echo "l)查看wx2tg日志"
echo "i)编译wx2tg镜像"
echo "c)自定义操作"

cd ~/Docker
mkdir -p wx2tg
cd wx2tg
ln -sf ../.env .env

echo "请选择: "
read choice

case $choice in
    u)
        echo "开始更新..."
        export IMAGE_NAME=hououinkami/wechat2tg-pad:kami
        updateContainer "wx2tg-pad"
        exit 0
        ;;
    a)
        echo "开始更新..."
        export IMAGE_NAME=hououinkami/wechat2tg-pad:kami
        updateContainer "wx2tg-redis"
        updateContainer "wx2tg-server"
        updateContainer "wx2tg-pad"
        exit 0
        ;;
    t)
        echo "使用自编译的测试版镜像并挂载文件..."
        export IMAGE_NAME=hououinkami/wechat2tg-pad:kami
        export CONTAINER_DIR=/app/src
        updateContainer "wx2tg-pad" true true
        exit 0
        ;;
    r)
        echo "重启wx2tg容器..."
        docker restart wx2tg-pad
        echo "查看wx2tg容器日志..."
        docker logs -f wx2tg-pad
        exit 0
        ;;
    l)
        echo "查看wx2tg容器日志..."
        docker logs -f wx2tg-pad
        exit 0
        ;;
    i)
        echo "触发编译wx2tg镜像..."
        source ../.env
        curl -X POST \
          -H "Accept: application/vnd.github+json" \
          -H "Authorization: Bearer ${GITHUB_TOKEN}" \
          -H "X-GitHub-Api-Version: 2022-11-28" \
          "https://api.github.com/repos/hououinkami/docker/actions/workflows/wx2tg.yml/dispatches" \
          -d '{
            "ref": "main"
          }'
        curl -X POST \
          -H "Accept: application/vnd.github+json" \
          -H "Authorization: Bearer ${GITHUB_TOKEN}" \
          -H "X-GitHub-Api-Version: 2022-11-28" \
          "https://api.github.com/repos/hououinkami/docker/actions/workflows/wx2tg-share.yml/dispatches" \
          -d '{
            "ref": "main"
          }'
        exit 0
        ;;
    c)
        ;;
    
    *)
        echo "退出！"
        exit 1
        ;;
esac

echo "请选择要使用的镜像:"
echo "1) wx2tg-dev(tag)"
echo "2) wx2tg-mac"

echo "请选择: "
read choice

case $choice in
    1)
        echo "使用自编译的测试版镜像..."
        read -p "请输入镜像标签 [默认: latest]: " tag
        tag=${tag:-latest}
        export IMAGE_NAME="hououinkami/wechat2tg-pad:$tag"
        updateContainer "wx2tg-pad"
        ;;
    2)
        echo "使用finalpi的正式版镜像..."
        export IMAGE_NAME=finalpi/wechat2tg-pad:latest
        export CONTAINER_DIR=/app/src
        updateContainer "wx2tg-pad" true true
        ;;
    *)
        echo "退出！"
        exit 1
        ;;
esac
