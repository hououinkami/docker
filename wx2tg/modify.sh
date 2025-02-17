cp ./utils.ts ./wechat2tg/src/client/utils.ts

source ./localize.sh

cd ./wechat2tg/src/client
awk_script='NR == 1 {print "import { translateMessageType } from '\''./utils'\'';"}'

for key in ${(k)localize}; do
    value=${localize[$key]}
    awk_script+="/$key/ {gsub(/$key/, \"$value\");} "
done

awk "$awk_script 1" WechatClient.ts > temp && mv temp WechatClient.ts
awk "$awk_script 1" TelegramBotClient.ts > temp && mv temp TelegramBotClient.ts
awk "$awk_script 1" FileHelperClient.ts > temp && mv temp FileHelperClient.ts