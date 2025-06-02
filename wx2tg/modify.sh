#!/bin/bash

source ./localize.sh

awk_script=''
wx_script=''
tg_script='
/TG贴纸ID:/ {
    print $0;
    print "                ctx.reply(`${ctx.message.sticker.file_unique_id}`, {";
    print "                    reply_parameters: {";
    print "                        message_id: messageId";
    print "                    }";
    print "                })";
    next;
}
'

# 定义处理单个键的函数
process_key() {
    local key="$1"
    # local escaped_key=$(echo "$key" | sed 's/[\/.*+?|()^$\[\]{}\\]/\\&/g')
    local escaped_key=$(echo "$key" | sed 's/\\/\\\\/g' | sed 's/\//\\\//g')
    local value="${localize[$key]}"
    # local escaped_value=$(echo "$value" | sed 's/[\"\\]/\\&/g')
    local escaped_value=$(echo "$value" | sed 's/\\/\\\\/g' | sed 's/\//\\\//g')
    awk_script+="/$escaped_key/ {gsub(/$escaped_key/, \"$escaped_value\");} "
}

# 定义遍历函数，根据不同的shell使用不同的遍历方式
if [ -n "$ZSH_VERSION" ]; then
    for_each_key() {
        for key in "${(k)localize[@]}"; do
            process_key "$key"
        done
    }
else
    for_each_key() {
        for key in "${!localize[@]}"; do
            process_key "$key"
        done
    }
fi

# 调用遍历函数
# for_each_key

# 新增自定义ts
addFile() {
    curl -o ../wechat2tg/src/util/handleMsg.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/ts/handleMsg.ts
    curl -o ../wechat2tg/src/util/handleSticker.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/ts/handleSticker.ts
    curl -o ../wechat2tg/src/util/stickerLoader.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/ts/stickerLoader.ts
}
# addFile

# 替换文件部分字符
adaptFile() {
    cd client
    awk "$awk_script 1" WechatClient.ts > temp && mv temp WechatClient.ts
    awk "$awk_script 1" TelegramBotClient.ts > temp && mv temp TelegramBotClient.ts
    cd ../service
    awk "$awk_script 1" TelegramCommandHelper.ts > temp && mv temp TelegramCommandHelper.ts
    awk "$awk_script 1" ConfigurationService.ts > temp && mv temp ConfigurationService.ts
    cd ../util
    awk "$awk_script 1" MessageTypeUtils.ts > temp && mv temp MessageTypeUtils.ts
    # emoji
    awk '
        /<a href=.*png.*>/ {
            gsub(/\$\{EmojiConverter\.emojiUrl\}.*png/, ""); 
            # http://www.localhost.com/404.png
        }
        { print }
    ' EmojiUtils.ts > temp && mv temp EmojiUtils.ts
    cd ../../
    }
# cd ../wechat2tg/src
# adaptFile
