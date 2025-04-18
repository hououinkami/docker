import { parseStringPromise } from 'xml2js';
import { MessageTypeUtils } from './MessageTypeUtils'

export async function handleMsg(
  msg: { type: () => any; text: () => string }
) {
  if (msg.type() === "chat_histroy") {
    const chatHistory = await getChatHistory(msg.text());
    return `${chatHistory}`;
  } else if (msg.type() === "123") {
    return `${msg.text()}`;
  } else {
    return MessageTypeUtils.getTypeName(msg.type() + '');
  }
}

async function getChatHistory(msgText: string): Promise<string> {
  const xmlString = await cleanXmlString(msgText)
  try {
    // 解析主XML
    const result = await parseStringPromise(xmlString);
    // 获取标题
    const title = result.msg.appmsg[0].title;
    // 解析recorditem
    const recorditemXml = result.msg.appmsg[0].recorditem;
    const recordData = await parseStringPromise(recorditemXml);
    // 获取第一项的日期
    const firstItemDate = recordData.recordinfo.datalist[0].dataitem[0].sourcetime[0].split(' ')[0];
    // 构建聊天记录
    let chatHistory = `${title}\n${firstItemDate}\n`;
    // 遍历所有聊天信息
    const dataItems = recordData.recordinfo.datalist[0].dataitem;
    dataItems.forEach((item: { 
      sourcename: string[], 
      sourcetime: string[], 
      datadesc: string[] 
    }) => {
      chatHistory += `${item.sourcename[0]}(${item.sourcetime[0].split(' ')[1]})\n${item.datadesc[0]}\n`;
    });
    // 适配Telegram的HTML模式
    const lines = chatHistory.split('\n');
    // 前两行合成一个引用块
    let htmlLines = [];
    if (lines.length >= 2) {
      htmlLines.push(`<blockquote>${lines[0]}\n${lines[1]}</blockquote>`);
    }
    // 处理剩余行
    for (let i = 2; i < lines.length; i++) {
      // 发送者匹配：任意文本(时间)
      if (/^.+\(\d{2}:\d{2}\)$/.test(lines[i])) {
        htmlLines.push(`<blockquote>${lines[i]}</blockquote>`);
      } else {
        htmlLines.push(lines[i]);
      }
    }
    const htmlText = htmlLines.join('\n');

    return htmlText;
    
  } catch (error) {
    console.error('チャット履歴処理エラー:', error);
    return '[チャット履歴]';
  }
}

// XML文本转换函数
async function cleanXmlString(input: string) {
  // 如果输入不是字符串，转换为字符串
  if (typeof input !== 'string') {
    input = String(input);
  }
  
  // 1. 处理字符串连接
  if (input.includes('+')) {
    const parts = input.split('+').map(part => part.trim());
    const cleanedParts = parts.map(part => {
      if ((part.startsWith("'") && part.endsWith("'")) || 
          (part.startsWith('"') && part.endsWith('"'))) {
        return part.slice(1, -1);
      }
      return part;
    });
    input = cleanedParts.join('');
  }
  
  // 2. 去除整个字符串可能的外层引号
  while ((input.startsWith("'") && input.endsWith("'")) || 
         (input.startsWith('"') && input.endsWith('"'))) {
    input = input.slice(1, -1);
  }
  
  // 3. 处理转义序列
  input = input.replace(/\\n/g, '\n')
               .replace(/\\t/g, '\t')
               .replace(/\\r/g, '\r')
               .replace(/\\\\/g, '\\')
               .replace(/\\'/g, "'")
               .replace(/\\"/g, '"');
  
  // 4. 关键修复：去除XML标签之间的引号
  input = input.replace(/>\s*(['"])\s*</g, '><');
  
  // 5. 去除每行开头的引号（这是你现在遇到的问题）
  input = input.replace(/(\r?\n)(['"])/g, '$1');
  
  // 6. 确保没有任何单独的引号在XML标签外部
  const lines = input.split('\n');
  for (let i = 0; i < lines.length; i++) {
    // 如果一行以引号开头，去掉这个引号
    if (lines[i].trim().startsWith("'") || lines[i].trim().startsWith('"')) {
      lines[i] = lines[i].replace(/^\s*['"]/, '');
    }
    // 如果一行以引号结尾，去掉这个引号
    if (lines[i].trim().endsWith("'") || lines[i].trim().endsWith('"')) {
      lines[i] = lines[i].replace(/['"]\s*$/, '');
    }
  }
  input = lines.join('\n');
  
  // 7. 最后的修剪
  input = input.trim();
  
  return input;
}
