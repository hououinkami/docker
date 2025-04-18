import { parseStringPromise } from 'xml2js';

export async function handleMsg(
  msg: { type: () => string; text: () => string },
  getChatHistory: (xml: string) => Promise<string>
) {
  if (msg.type() === 'chat_histroy') {
    const chatHistory = await getChatHistory(msg.text());
    return `${chatHistory}`;
  } else if (msg.type() === 'yyy') {
    // 操作2
    return `${msg.text()}`;
  } else {
    return `${msg.text()}`;
  }
}

export async function getChatHistory(msgText: string): Promise<string> {
  // 1. 解析XML
  const result = await parseStringPromise(msgText, { explicitArray: false });

  // 2. 获取title
  const title = result.msg.title || '';

  // 3. 获取消息列表
  const dataitems = result.msg.datalist.dataitem;
  // 处理单条和多条消息的情况
  const msgArray = Array.isArray(dataitems) ? dataitems : [dataitems];

  // 4. 组装内容
  type MsgItem = {
    sourcename: string;
    sourcetime: string;
    datadesc: string;
  };

  const msgs: MsgItem[] = msgArray.map((item: any) => ({
    sourcename: item.sourcename,
    sourcetime: item.sourcetime,
    datadesc: item.datadesc,
  }));

  // 5. 取第一个消息的日期，转为YY-MM-DD
  let dateStr = '';
  if (msgs.length > 0 && msgs[0].sourcetime) {
    const [y, m, d] = msgs[0].sourcetime.split(' ')[0].split('-');
    dateStr = `${y.slice(2)}-${m.padStart(2, '0')}-${d.padStart(2, '0')}`;
  }

  // 6. 组装文本
  let chatHistory = `${title}\n${dateStr}\n`;
  msgs.forEach(msg => {
    const time = msg.sourcetime.split(' ')[1];
    chatHistory += `${msg.sourcename}(${time})：\n${msg.datadesc}\n`;
  });
  
  // 7. 适配Telegram的HTML模式
  const lines = chatHistory.split('\n');
  // 前两行合成一个引用块
  let htmlLines = [];
  if (lines.length >= 2) {
    htmlLines.push(`<blockquote>${lines[0]}<br>${lines[1]}</blockquote>`);
  }
  // 处理剩余行
  for (let i = 2; i < lines.length; i++) {
    // 发送者匹配：任意文本(时间)，如 AA(16:45)
    if (/^.+\(\d{2}:\d{2}\)$/.test(lines[i])) {
      htmlLines.push(`<blockquote>${lines[i]}</blockquote>`);
    } else {
      htmlLines.push(lines[i]);
    }
  }
  // 用<br>连接
  const htmlText = htmlLines.join('<br>');

  return chatHistory;
}
