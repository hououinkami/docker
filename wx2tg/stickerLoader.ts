import fs from 'fs';
import path from 'path';

// 定义类型
interface StickerInfo {
  md5: string;
  size: number;
}

interface StickerData {
  stickerToEmojiMap: {
    [stickerId: string]: StickerInfo;
  };
}

// 缓存变量
let stickerDataCache: StickerData | null = null;
let lastModified = 0;

// 配置文件路径
const stickerInfoPath = path.join('./sticker.json'); 

/**
 * 获取贴纸信息，带缓存机制
 * @param forceReload 是否强制重新加载
 * @returns 贴纸数据
 */
export function getStickerData(forceReload = false): StickerData {
  try {
    // 检查文件是否存在
    if (!fs.existsSync(stickerInfoPath)) {
      console.error('Sticker info file not found:', stickerInfoPath);
      return { stickerToEmojiMap: {} };
    }

    // 获取文件状态
    const stats = fs.statSync(stickerInfoPath);
    const currentModified = stats.mtimeMs;

    // 如果有缓存且文件未更新且不强制重载，返回缓存
    if (!forceReload && stickerDataCache && lastModified === currentModified) {
      return stickerDataCache;
    }

    // 读取并解析文件
    const fileContent = fs.readFileSync(stickerInfoPath, 'utf8');
    const data: StickerData = JSON.parse(fileContent);

    // 更新缓存和时间戳
    stickerDataCache = data;
    lastModified = currentModified;

    console.log('Sticker info loaded from file');
    return data;
  } catch (error) {
    console.error('Error loading sticker info:', error);
    
    // 如果出错但有缓存，返回缓存
    if (stickerDataCache) {
      console.log('Using cached sticker data due to error');
      return stickerDataCache;
    }
    
    // 否则返回空对象
    return { stickerToEmojiMap: {} };
  }
}

/**
 * 获取贴纸到表情的映射
 * @returns 贴纸映射对象
 */
export function getStickerToEmojiMap(): { [stickerId: string]: StickerInfo } {
  return getStickerData().stickerToEmojiMap;
}

// 可选：添加文件监听，自动更新缓存
try {
  fs.watch(path.dirname(stickerInfoPath), (eventType, filename) => {
    if (filename === path.basename(stickerInfoPath) && eventType === 'change') {
      // 文件变化时，下次获取时会重新加载
      console.log('Sticker info file changed, cache will be updated on next access');
    }
  });
} catch (error) {
  console.warn('Unable to watch sticker info file for changes:', error);
}
