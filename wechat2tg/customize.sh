cd ~/Docker/wx2tg && \

# 日语本地化
cd src/i18n/locales
curl -o zh.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wechat2tg/ja.ts && \
cd -

# 取消发送临时文件
cd src/client
curl -o WechatClient.ts https://raw.githubusercontent.com/finalpi/wechat2tg/refs/heads/master/src/client/WechatClient.ts && \
perl -0777 -i -pe "s/(.*)sender\.sendFile.*?wechat\.receivingFile.*?}/\1sender\.sendText(tgMessage\.chatId, this\.t('wechat\.receivingFile')/s" WechatClient.ts && \

# 自定义特殊消息类型提示文本
awk '
    /\$\{this\.getMessageName/ { 
        gsub(/\[|\]/, ""); 
    }
    /\$\{this\.t.*wechat\.plzViewOnPhone.*\}/ { 
        gsub(/, \$\{this\.t.*wechat\.plzViewOnPhone[^\}]*\}/, "、${this.t('\''wechat.plzViewOnPhone'\'')}"); 
    }
    {
        if ($0 ~ /\$\{this\.t.*wechat\.get.*(\$\{this\.[^\}]*\})/) {
            if ($0 ~ /\$\{this\.t.*common.error.*\}/) {
                gsub(/\$\{this\.t.*wechat\.get.*\$\{this\.t.*common.error[^\}]*\}/, "${this.getMessageName(message.type())}${this.t('\''wechat.get'\'')}${this.t('\''common.error'\'')}");
            }
            if ($0 !~ /\$\{this\.t.*common.error.*\}/ && $0 !~ /wechat\.plzViewOnPhone/) {
                gsub(/\$\{this\.t.*wechat.getOne.*\$/,"$");
                gsub(/\}`/,"}${this.t('\''wechat.get'\'')}`");     
            }
            if ($0 !~ /\$\{this\.t.*common.error.*\}/ && $0 ~ /wechat\.plzViewOnPhone/) {
                gsub(/\$\{this\.t.*wechat.get[^\}]*\} /,"");
                gsub(/\$\{this\.t.*wechat.get[^\}]*\}/,"");
                gsub(/、/,"を${this.t('\''wechat.get'\'')}、"); 
                gsub(/的名片消息/,"の連絡先カード");   
            }
        }
    }
    { print }
' WechatClient.ts > temp && mv temp WechatClient.ts
