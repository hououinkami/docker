#!/bin/bash

echo "请选择要进行的操作:"
echo "1)更新"
echo "2)重启容器"
echo "3)查看日志"
echo "4)编译镜像"
echo "5)备份gewechat镜像"

read -p "请选择: " choice

case $choice in
    1)
        cd ~/Docker
        mkdir -p wx2tg
        cd wx2tg
        ln -sf ../.env .env
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
    4)
        echo "触发编译arm镜像..."
        set -euo pipefail
        KAMI_TOKEN="${KAMI_TOKEN:-}"
        curl -X POST \
          -H "Accept: application/vnd.github+json" \
          -H "Authorization: Bearer $KAMI_TOKEN" \
          -H "X-GitHub-Api-Version: 2022-11-28" \
          "https://api.github.com/repos/hououinkami/docker/actions/workflows/wx2tg/dispatches" \
          -d '{
            "ref": "main",  # 触发分支
            "inputs": {
              "environment": "production"  # 可选输入参数
            }
          }'
        unset KAMI_TOKEN
        exit 0
        ;;
    5)
        echo "备份当前使用的gewechat镜像..."
        cd ~/Docker
        docker save -o "gewechat_arm_$(date +'%m%d%H%M').tar" registry.cn-chengdu.aliyuncs.com/tu1h/wechotd:alpine
        exit 0
        ;;
    *)
        echo "退出！"
        exit 1
        ;;
esac

echo "请选择要使用的镜像:"
echo "1) 测试版"
echo "2) 正式版"
echo "3) 测试版（挂载测试文件）"

read -p "请选择: " choice

case $choice in
    1)
        echo "使用自编译的测试版镜像..."
        export IMAGE_NAME=hououinkami/wechat2tg-pad:latest
        ;;
    2)
        echo "使用finalpi的正式版镜像..."
        export IMAGE_NAME=finalpi/wechat2tg-pad:latest
        export CONTAINER_DIR=/app/src
        git clone --filter=blob:none --no-checkout https://github.com/finalpi/wechat2tg.git ../wechat2tg
        cd ../wechat2tg
        git sparse-checkout init --cone
        git sparse-checkout set src
        git checkout wx2tg-pad-dev
        rm -rf ../wx2tg/src && mv -f src ../wx2tg
        cd .. && rm -rf wechat2tg
        cd wx2tg
        ;;
    3)
        echo "测试模式..."
        export IMAGE_NAME=hououinkami/wechat2tg-pad:latest
        export CONTAINER_DIR=/app/src
        git clone --filter=blob:none --no-checkout https://github.com/finalpi/wechat2tg.git ../wechat2tg
        cd ../wechat2tg
        git sparse-checkout init --cone
        git sparse-checkout set src
        git checkout wx2tg-pad-dev
        rm -rf ../wx2tg/src && mv -f src ../wx2tg
        cd .. && rm -rf wechat2tg
        cd wx2tg
        ;;
    *)
        echo "退出！"
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
        curl -o localize.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/localize.sh
        curl -o modify.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/modify.sh
        zsh modify.sh
        curl -o docker-compose.yaml https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg-pad.yaml
        docker compose pull wechat2tg
        docker-compose up -d --no-deps --remove-orphans wechat2tg
        docker image prune --force
        ;;
    2)
        echo "正在更新gewechat..."
        curl -o docker-compose.yaml https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg-pad.yaml
        docker compose pull gewechat
        docker-compose up -d --no-deps --remove-orphans gewechat
        docker image prune --force
        ;;
    3)
        echo "正在更新..."
        curl -o localize.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/localize.sh
        curl -o modify.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/modify.sh
        zsh modify.sh
        curl -o docker-compose.yaml https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg-pad.yaml
        docker compose pull
        docker-compose up -d --remove-orphans
        docker image prune --force
        ;;
    *)
        echo "退出！"
        exit 1
        ;;
esac
