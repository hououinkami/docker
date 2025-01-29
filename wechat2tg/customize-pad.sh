cd ~/Docker/wx2tg && \
# 下载src文件夹
git clone --filter=blob:none --no-checkout https://github.com/finalpi/wechat2tg.git
cd wechat2tg
git sparse-checkout init --cone
git sparse-checkout set src
git checkout wx2tg-pad-dev
rm -rf ../src && mv -f src ../
cd .. && rm -rf wechat2tg
