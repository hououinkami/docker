#!/bin/bash

# 定义函数
updateContainer() {
    if [ "$3" = "true" ]; then
        git clone --filter=blob:none --no-checkout https://github.com/finalpi/wechat2tg.git ../wechat2tg
        cd ../wechat2tg
        git sparse-checkout init --cone
        git sparse-checkout set src
        git checkout wx2tg-pad-dev
        cd wx2tg
        curl -o localize.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/localize.sh
        curl -o modify.sh https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/modify.sh
        zsh modify.sh
        rm -rf ./src && mv -f ../wechat2tg/src ./
        rm -rf ../wechat2tg
    fi
    curl -o docker-compose.yaml https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg-pad.yaml
    # docker compose pull $1
    if [ "$2" = "false" ]; then
        pull="missing"
    else
        pull="always"
    fi
    docker-compose up -d --no-deps --remove-orphans --pull "$pull" "$1"
    docker image prune --force
}

# 获取当前日期时间
timeinfo=$(date +%m%d%H%M)

# 更新脚本
echo "$timeinfo请选择要进行的操作:"
echo "u)更新wx2tg"
echo "r)重启wx2tg容器"
echo "l)查看wx2tg日志"
echo "i)编译wx2tg镜像"
echo "b)备份gewe镜像"
echo "c)自定义更新"
echo "f)重新登陆微信传输助手"

cd ~/Docker
mkdir -p wx2tg
cd wx2tg
ln -sf ../.env .env

read -p "请选择: " choice

case $choice in
    u)
        export IMAGE_NAME=hououinkami/wechat2tg-pad:latest
        updateContainer "wechat2tg"
        exit 0
        ;;
    r)
        echo "重启wx2tg容器..."
        docker restart wx2tg
        exit 0
        ;;
    l)
        echo "查看wx2tg容器日志..."
        docker logs -f wx2tg
        exit 0
        ;;
    i)
        echo "触发编译arm镜像..."
        source ../.env
        curl -X POST \
          -H "Accept: application/vnd.github+json" \
          -H "Authorization: Bearer ${GITHUB_TOKEN}" \
          -H "X-GitHub-Api-Version: 2022-11-28" \
          "https://api.github.com/repos/hououinkami/docker/actions/workflows/wx2tg.yml/dispatches" \
          -d '{
            "ref": "main"
          }'
        exit 0
        ;;
    b)
        echo "备份当前使用的gewechat镜像..."
        cd ~/Docker
        docker save -o "gewechat_arm_$(date +'%m%d%H%M').tar" registry.cn-chengdu.aliyuncs.com/tu1h/wechotd:alpine
        exit 0
        ;;
    c)
        ;;
    f)
        echo "删除文件传输助手登陆信息并重启容器"
        rm -rf ./config/fileHelper.memory-card.json
        docker restart wx2tg
        exit 0
        ;;
    
    *)
        echo "退出！"
        exit 1
        ;;
esac

echo "请选择要使用的镜像:"
echo "1) wx2tg-dev"
echo "2) wx2tg-dev(hot-fix)"
echo "3) wx2tg-dev(debug)"
echo "4) wx2tg-pad"
echo "5) gewe-wechotd"
echo "6) gewe-self"

read -p "请选择: " choice

case $choice in
    1)
        echo "使用自编译的测试版镜像..."
        read -p "请输入镜像标签 [默认: latest]: " tag
        tag=${tag:-latest}
        export IMAGE_NAME="hououinkami/wechat2tg-pad:$tag"
        updateContainer "wechat2tg"
        ;;
    2)
        echo "使用自编译的测试版镜像并挂载文件..."
        export IMAGE_NAME=hououinkami/wechat2tg-pad:latest
        export CONTAINER_DIR=/app/src
        updateContainer "wechat2tg" true true
        ;;
    3)
        echo "启用DEBUG模式..."
        export DEBUG_MODE=true
        export IMAGE_NAME=hououinkami/wechat2tg-pad:latest
        updateContainer "wechat2tg"
        ;;
    4)
        echo "使用finalpi的正式版镜像..."
        export IMAGE_NAME=finalpi/wechat2tg-pad:latest
        export CONTAINER_DIR=/app/src
        updateContainer "wechat2tg" true true
        ;;
    5)
        echo "使用wechotd镜像更新gewechat..."
        export IMAGE_NAME_GEWE=registry.cn-chengdu.aliyuncs.com/tu1h/wechotd:alpine
        updateContainer "gewechat"
        ;;
    6)
        echo "使用自编译镜像更新gewechat..."
        read -p "是否更新自编译镜像？ [默认: false]: " update
        update=${update:-false}
        export IMAGE_NAME_GEWE=hououinkami/gewe:latest
        updateContainer "gewechat" "$update"
        ;;
    *)
        echo "退出！"
        exit 1
        ;;
esac
