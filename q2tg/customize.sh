cd ~/Docker/q2tg && \
# 下载src文件夹
git clone --filter=blob:none --no-checkout https://github.com/clansty/Q2TG.git
cd Q2TG
git sparse-checkout init --cone
git sparse-checkout set ui main
git checkout sleepyfox
rm -rf ../ui && mv -f ui ../
rm -rf ../main && mv -f main/src ../main && mv -f main/build.ts ../main/build.ts
cd .. && rm -rf Q2TG
