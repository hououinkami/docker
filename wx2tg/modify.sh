#!/bin/bash

source ./localize.sh

awk_script='/blockquote expandable/ {gsub(/blockquote expandable/,"blockquote");} '
wx_script='
NR == 1 {
    print "import {handleMsg} from '\''../util/handleMsg'\''";
    print "import {saveEmoji, verifyJsonFile} from '\''../util/handleSticker'\''";
}
/this\.client\.Message\.Type\.Emoji === msg\.type\(\)/ {
    print $0;
    print "// eslint-disable-next-line @typescript-eslint/ban-ts-comment";
    print "// @ts-ignore";
    print "const wxEmoji = msg.emoji";
    print " saveEmoji(wxEmoji)";
    print ".then(id => console.log('\''保存成功，ID:'\'', id))";
    print ".catch(err => console.error('\''保存失败:'\'', err));";
    print "verifyJsonFile();";
    next;
}
'
tg_script='
NR == 1 {
    print "import {handleSticker} from '\''../util/handleSticker'\''";
}
/const fileId = ctx\.message\.sticker\.file_id/ {
    print $0;
    print "const stickerHandled = await handleSticker(ctx, exist);";
    print "if (stickerHandled) { return; } else { console.log('\''TG贴纸ID:'\'', ctx.message.sticker.file_id)}";
    next;
}
'

# 定义处理单个键的函数
process_key() {
    local key="$1"
    local escaped_key=$(echo "$key" | sed 's/[\/.*+?|()^$\[\]{}\\]/\\&/g')
    local value="${localize[$key]}"
    local escaped_value=$(echo "$value" | sed 's/[\"\\]/\\&/g')
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
for_each_key

# 新增自定义ts
curl -o ../wechat2tg/src/util/handleMsg.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/handleMsg.ts
curl -o ../wechat2tg/src/util/handleSticker.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/handleSticker.ts
curl -o ../wechat2tg/src/util/stickerLoader.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wx2tg/stickerLoader.ts

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
