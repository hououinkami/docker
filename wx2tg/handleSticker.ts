import { Emoji } from 'gewechaty'
import { TelegramBotClient } from '../client/TelegramBotClient';
import { getStickerToEmojiMap } from './stickerLoader';

export async function handleSticker(ctx: any, bindItem: any): Promise<boolean> {
    // 获取贴纸ID
    const stickerId = ctx.message.sticker.file_id;
    
    // 如果没有贴纸ID，直接返回 false 继续后续操作
    if (!stickerId) {
        return false;
    }

    const stickerToEmojiMap = getStickerToEmojiMap();
    
    // 遍历映射表查找匹配的贴纸
    for (const [mappedStickerId, emojiInfo] of Object.entries(stickerToEmojiMap)) {
        if (stickerId === mappedStickerId) {
        try {
            // 创建表情对象
            const emoji = new Emoji({
                emojiMd5: emojiInfo.md5,
                emojiSize: emojiInfo.size
            });

            // 查找联系人并发送表情
            const currentContract = await TelegramBotClient.getSpyClient('wxClient').client.Contact.find({id: bindItem.wxId});
            await currentContract.say(emoji);
            
            // 返回 true 表示已处理，中断后续操作
            return true;
        } catch (error) {
            console.error('ステッカー送信失敗:', error);
            return false;
        }
        }
    }

    // 没有找到匹配的贴纸，返回 false 继续后续操作
    return false;
}
