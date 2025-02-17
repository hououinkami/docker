cp ./utils.ts ./wechat2tg/src/client/utils.ts

cd ./wechat2tg/src/client
awk '
    NR == 1 {
        print "import { translateMessageType } from '\''./utils'\'';"
    }
    /emoji\.gif/ {
        gsub(/emoji\.gif/, "ステッカー.gif");
    }
    /收到一条/ {
        # 在当前行之前插入一行
        print "const translatedType = translateMessageType(msg.type());";
        gsub(/收到一条/, "");
        gsub(/消息，请在手机上查看/, "");
        gsub(/\$\{msg\.type\(\)\}/, "[${translatedType}]");
    }
    { print }
' WechatClient.ts > temp && mv temp WechatClient.ts
awk '
    /temp_file/ {
        gsub(/temp_file/, "ファイル");
    }
    /文件接收中/ {
        gsub(/文件接收中/, ""); 
    }
    /使用文件传输助手接收/ {
        gsub(/使用文件传输助手接收/, "ファイル転送で受信"); 
    }
    { print }
' TelegramBotClient.ts > temp && mv temp TelegramBotClient.ts
