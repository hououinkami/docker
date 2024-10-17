import discord
import os
from discord.ext import commands

# 環境変数から設定を取得
TOKEN = os.getenv('DISCORD_TOKEN')
SOURCE_CHANNEL_ID = int(os.getenv('SOURCE_CHANNEL_ID'))
TARGET_CHANNEL_ID = int(os.getenv('TARGET_CHANNEL_ID'))

bot = commands.Bot(command_prefix='!')

@bot.event
async def on_ready():
    print(f'Logged in as {bot.user}!')

@bot.event
async def on_message(message):
    if message.channel.id == SOURCE_CHANNEL_ID:  # AチャンネルのID
        target_channel = bot.get_channel(TARGET_CHANNEL_ID)  # BチャンネルのID
        await target_channel.send(message.content)

# ボットを実行
bot.run(TOKEN)
