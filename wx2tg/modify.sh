source ./localize.sh

awk_script='/blockquote expandable/ {gsub(/blockquote expandable/,"blockquote");} '

for key in "${!localize[@]}"; do
    value="${localize[$key]}"
    awk_script+="/$key/ {gsub(/$key/, \"$value\");} "
done

cd ./src/client
awk "$awk_script 1" WechatClient.ts > temp && mv temp WechatClient.ts
awk "$awk_script 1" TelegramBotClient.ts > temp && mv temp TelegramBotClient.ts
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