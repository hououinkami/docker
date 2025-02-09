cd ~/Docker/wx2tg && \
# 下载src文件夹
git clone --filter=blob:none --no-checkout https://github.com/finalpi/wechat2tg.git
cd wechat2tg
git sparse-checkout init --cone
git sparse-checkout set src
git checkout wx2tg-pad
rm -rf ../src && mv -f src ../
cd .. && rm -rf wechat2tg

cd src/client
awk '
    /emoji\.gif/ {
        gsub(/emoji\.gif/, "ステッカー.gif");
    }
    /收到一条/ {
        gsub(/收到一条/, "⚠️"); 
        gsub(/消息，请在手机上查看/, "を受信");
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
    { print }
' TelegramBotClient.ts > temp && mv temp TelegramBotClient.ts
cd -
