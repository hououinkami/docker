cd ~/Docker/wx2tg && \
# 下载src文件夹
git clone --filter=blob:none --no-checkout https://github.com/finalpi/wechat2tg.git
cd wechat2tg
git sparse-checkout init --cone
git sparse-checkout set src
git checkout wx2tg-pad-dev
rm -rf ../src && mv -f src ../
cd .. && rm -rf wechat2tg

cd src/client
curl -o utils.ts https://raw.githubusercontent.com/hououinkami/docker/refs/heads/main/wechat2tg/utils.ts
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
        gsub(/\$\{msg\.type\(\)\}/, "${translatedType}");
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
cd -
