cd ~/Docker/wx2tg && \
# 下载src文件夹
git clone --filter=blob:none --no-checkout https://github.com/finalpi/wechat2tg.git
cd wechat2tg
git sparse-checkout init --cone
git sparse-checkout set src
git checkout master
rm -rf ../src && mv -f src ../
cd .. && rm -rf wechat2tg

# 日语本地化
cd src/i18n/locales
curl -o zh.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wechat2tg/ja.ts && \
cd -

cd src/client
# curl -o WechatClient.ts https://raw.githubusercontent.com/finalpi/wechat2tg/refs/heads/master/src/client/WechatClient.ts && \
# 发送的临时文件名更改为对应的消息类型
sed -i '' 's/'\''temp_file'\''/`\${this.getMessageName(messageType)}`/g' WechatClient.ts && \
# 取消发送临时文件（会导致部分错误提示无法收到）
# perl -0777 -i -pe "s/(.*)sender\.sendFile.*?wechat\.receivingFile.*?}/\1sender\.sendText(tgMessage\.chatId, this\.t('wechat\.receivingFile')/s" WechatClient.ts && \

# 自定义特殊消息类型提示文本
awk '
    # 删除消息类型的中括号
    /\$\{this\.getMessageName/ { 
        gsub(/\[|\]/, ""); 
    }
    /\$\{this\.t.*wechat\.messageType\.setMsg.*/ {
        gsub(/\[\$\{this\.t.*wechat\.messageType\.setMsg.*\]/, "${this.t('\''wechat.messageType.setMsg'\'')}${this.t('\''wechat.get'\'')}、");
    }
    # 替换消息中的英文逗号为日文逗号
    /\$\{this\.t.*wechat\.plzViewOnPhone.*\}/ { 
        gsub(/, \$\{this\.t.*wechat\.plzViewOnPhone[^\}]*\}/, "、${this.t('\''wechat.plzViewOnPhone'\'')}"); 
    }
    # 消息的语法更改为日语
    {
        if ($0 ~ /\$\{this\.t.*wechat\.get.*(\$\{this\.[^\}]*\})/) {
            if ($0 ~ /\$\{this\.t.*common.error.*\}/) {
                gsub(/\$\{this\.t.*wechat\.get.*\$\{this\.t.*common.error[^\}]*\}/, "${this.t('\''wechat.get'\'')}${this.t('\''common.error'\'')}");
            }
            if ($0 !~ /\$\{this\.t.*common.error.*\}/ && $0 !~ /wechat\.plzViewOnPhone/) {
                gsub(/\$\{this\.t.*wechat.getOne.*\$/, "$");
                gsub(/\}`/, "}${this.t('\''wechat.get'\'')}`");     
            }
            if ($0 !~ /\$\{this\.t.*common.error.*\}/ && $0 ~ /wechat\.plzViewOnPhone/) {
                gsub(/\$\{this\.t..wechat.get[^\}]*\} /, "");
                gsub(/\$\{this\.t..wechat.get[^\}]*\}/, "");
                gsub(/、/, "を${this.t('\''wechat.get'\'')}、"); 
                gsub(/的名片消息/, "の連絡先カード");   
            }
        }
    }
    # 引用消息块默认不隐藏
    /blockquote expandable/ {
        gsub(/blockquote expandable/,"blockquote");
    }
    /\$\{res\.des\} \.\.\./ {
        gsub(/\$\{res\.des\} \.\.\./,"${res.des}");
    }
    # 接受文件提示和失败提示加上发送者
    /this\.t.*wechat\.receivingFile../ {
        gsub(/this\.t.*wechat\.receivingFile../, "`${identityStr}${this.t('\''wechat.receivingFile'\'')}`");
    }
    /`\$\{this\.t..wechat\.get[^\}]*\}/ {
        gsub(/\$\{this\.t..wechat\.get[^\}]*\}/, "${identityStr}${this.t('\''wechat.get'\'')}");
    }
    { print }
' WechatClient.ts > temp && mv temp WechatClient.ts
cd -

# Emoji自定义
cd src/util
# curl -o EmojiUtils.ts https://raw.githubusercontent.com/finalpi/wechat2tg/refs/heads/master/src/util/EmojiUtils.ts && \
awk '
    /<a href=.*png.*>/ {
        gsub(/\$\{EmojiConverter\.emojiUrl\}.*png/, ""); 
        # http://www.localhost.com/404.png
    }
    { print }
' EmojiUtils.ts > temp && mv temp EmojiUtils.ts
cd -