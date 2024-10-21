# Pythonの公式イメージを使用
FROM python:3.11

# 作業ディレクトリを作成
WORKDIR /usr/src/app

# 必要なライブラリをインストール
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# ボットのコードをコピー
COPY bot.py ./

# ボットを実行
CMD ["python", "./bot.py"]
