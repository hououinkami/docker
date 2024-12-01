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
/, \$\{this\.t\('wechat\.plzViewOnPhone'\)\}/ {
    gsub(/, ${this.t('wechat.plzViewOnPhone')}/, "、${this.t('wechat.plzViewOnPhone')}")
}
/\$\{this\.getMessageName\(/ {
    gsub(/\[|\]/, "")
}
/\$\{this\.t\(.*wechat\.get.*\)\}(.*) \$\{this\.t\(.*common\.error.*\)\}/ {
    match($0, /\$\{this\.t\(.*wechat\.get.*\)\}(.*) \$\{this\.t\(.*common\.error.*\)\}/, m)
    $0 = m[1] "${this.t('wechat.get')}${this.t('common.error')}"
}
{ print }
' WechatClient.ts > temp && mv temp WechatClient.ts
