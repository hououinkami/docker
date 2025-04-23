#!/bin/bash

declare -A localize=(
    ["\`收到一条\\$\{MessageTypeUtils\.getTypeName\(msg\.type\(\) \+ ''\)\}消息，请在手机上查看\`"]="await handleMsg(msg, this.client.Message.Type)"
)

awk_script='/blockquote expandable/ {gsub(/blockquote expandable/,"blockquote");} '
wx_script='NR == 1 {print "import {handleMsg} from '\''../util/handleMsg'\''"} '
tg_script='
NR == 1 {print "import {Emoji} from '\''gewechaty'\''"}
{
    if ($0 ~ /const fileId = ctx\.message\.sticker\.file_id/ && !done) {
        print "const stickerHandled = await handleSticker(ctx, exist);"
        print "if (stickerHandled) { return; } else { console.log('\''TG贴纸ID:'\'', ctx.message.sticker.file_id)}"
        done = 1
    }
}
'

awk_script="$ex_script $awk_script"

if [ -n "$ZSH_VERSION" ]; then
    for key in "${(k)localize[@]}"; do
        value="${localize[$key]}"
        awk_script+="/$key/ {gsub(/$key/, \"$value\");} "
    done
else
    for key in "${!localize[@]}"; do
        value="${localize[$key]}"
        awk_script+="/$key/ {gsub(/$key/, \"$value\");} "
    done
fi

# 新增自定义ts
curl -o ../wechat2tg/src/util/handleMsg.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/handleMsg.ts
curl -o ../wechat2tg/src/util/handleSticker.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/handleSticker.ts
curl -o ../wechat2tg/src/util/stickerLoader.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/stickerLoader.ts
curl -o ../wechat2tg/src/util/sticker.json https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/sticker.json

cd ../wechat2tg/src/client
awk "$wx_script $awk_script 1" WechatClient.ts > temp && mv temp WechatClient.ts
awk "$tg_script $awk_script 1" TelegramBotClient.ts > temp && mv temp TelegramBotClient.ts
awk "$awk_script 1" FileHelperClient.ts > temp && mv temp FileHelperClient.ts
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
