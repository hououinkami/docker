import { parseStringPromise } from 'xml2js';
import { MessageTypeUtils } from './MessageTypeUtils'

export async function handleMsg(
  msg: { type: () => any; text: () => string }
) {
  if (msg.type() === "chat_histroy") {
    const chatHistory = await getChatHistory(msg);
    return `${chatHistory}`;
  } else if (msg.type() === "mini_app") {
    const miniProgram = await getMiniprogram(msg);
    return `${miniProgram}`;
  } else {
    return `[${MessageTypeUtils.getTypeName(msg.type() + '')}]`;
  }
}

// 处理聊天记录
async function getChatHistory(
  msg: { type: () => any; text: () => string }
): Promise<string> {
  const xmlString = await cleanXmlString(msg.text())
  try {
    // 解析主XML
    const result = await parseStringPromise(xmlString);
    // 获取标题
    // const title = result.msg.appmsg[0].title;
    const title = `[${MessageTypeUtils.getTypeName(msg.type() + '')}]`;
    // 解析recorditem
    const recorditemXml = result.msg.appmsg[0].recorditem;
    const recordData = await parseStringPromise(recorditemXml);
    const itemCount = recordData.recordinfo.datalist[0].$.count;
    // 获取第一项的日期
    const firstItemDate = recordData.recordinfo.datalist[0].dataitem[0].sourcetime[0].split(' ')[0].replace(/-/g, '/');
    // 获取最后一项的日期
    const datalistLength = recordData.recordinfo.datalist[0].dataitem.length;
    const lastIndex = datalistLength - 1;
    const lastItemDate = recordData.recordinfo.datalist[0].dataitem[lastIndex].sourcetime[0].split(' ')[0].replace(/-/g, '/');
    let titleDate = firstItemDate;
    let multiDays = false;
    if (firstItemDate !== lastItemDate) {
      multiDays = true;
      titleDate = `${firstItemDate}～${lastItemDate}`;
    }
    // 构建聊天记录
    let chatHistory = `${title}\n${titleDate}\n件数: ${itemCount}\n`;

    const dataItems = recordData.recordinfo.datalist[0].dataitem;
    // 创建数据类型映射
    let chatContent;
    const dataTypeMap = {
      1: "テクスト",
      2: "画像",
      4: "動画",
      5: "リンク",
      19: "ミニプログラム"
    };
    for (const item of dataItems) {
      // 获取数据类型
      const dataType = Number(item.$.datatype);  
      chatContent = item.datadesc?.[0] ?? "";
      if (dataType === 1) {
        chatContent = item.datadesc[0];
      } else if (dataType === 5) {
        chatContent = `<a href="${item.link[0]}">${item.datatitle[0]}</a>`
      } else if (dataType === 19) {
        chatContent = `[${dataTypeMap[dataType as keyof typeof dataTypeMap]}]\n${item.datatitle[0]}`;
      } else {
        chatContent = `[${dataTypeMap[dataType as keyof typeof dataTypeMap] || "不明"}]`
      }
      // 正确解析时间
      const timestamp = item.sourcetime[0];
      const { date, time } = await formatTime(timestamp);
      
      let chatTime = time;
      if (multiDays === true) {
        chatTime = `${date} ${time}`;
      }
      
      chatHistory += `👤${item.sourcename[0]}(${chatTime})\n${chatContent}\n`;
    }
    // 适配Telegram的HTML模式

    // 标题独立
    const lines = chatHistory.split('\n');
    // 前两行合成一个引用块
    let chatLines: string[] = [];
    const titleText = `${lines[0]}\n<blockquote>${lines[1]}</blockquote>`;
    // 处理剩余行
    for (let i = 2; i < lines.length; i++) {
      // 发送者匹配：任意文本(时间)
      if (/^.+\(\d{2}:\d{2}\)$/.test(lines[i]) || /^.+\(\d{2}\/\d{2} \d{2}:\d{2}\)$/.test(lines[i])) {
        chatLines.push(`${lines[i]}`);
      } else {
        chatLines.push(lines[i]);
      }
    }
    const chatText = chatLines.join('\n');
    // const htmlText = `${titleText}\n<blockquote expandable>${chatText}</blockquote>`;

    // 标题合并
    const htmlText = `<blockquote expandable>${chatHistory}</blockquote>`;

    return htmlText;
    
  } catch (error) {
    console.error('チャット履歴処理エラー:', error);
    return `[${MessageTypeUtils.getTypeName(msg.type() + '')}]`;
  }
}

// 处理小程序
async function getMiniprogram(
  msg: { type: () => any; text: () => string }
): Promise<string> {
  const xmlString = await cleanXmlString(msg.text())
  try {
    // 解析主XML
    const result = await parseStringPromise(xmlString);
    // 获取标题
    const miniprogramTitle = result.msg.appmsg[0].title[0];
    
    // 适配Telegram的HTML模式
    const htmlText = `[${MessageTypeUtils.getTypeName(msg.type() + '')}]\n${miniprogramTitle}`;

    return htmlText;
    
  } catch (error) {
    console.error('ミニプログラム処理エラー:', error);
    return `[${MessageTypeUtils.getTypeName(msg.type() + '')}]`;
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

async function formatTime(timestamp: string) {
  // 拆分日期和时间部分
  const [datePart, timePart] = timestamp.split(' ');

  // 从日期部分获取月/日
  const [year, month, day] = datePart ? datePart.split('-') : ['', '', ''];
  const date = `${month}/${day}`;

  // 从时间部分获取小时:分钟
  const [hour, minute] = timePart ? timePart.split(':') : ['', ''];
  const time = `${hour}:${minute}`;

  // 返回包含值的对象
  return {
    year,
    date,
    time
  };
}
