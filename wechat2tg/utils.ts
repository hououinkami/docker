export const translateMessageType = (rawType: string): string => {
  const typeMapping: { [key: string]: string } = {
    'link': 'リンク',
    'video_account': 'チャンネル',
    'mini_app': 'ミニプログラム',
    'pat': '軽く叩い'
  };
  return typeMapping[rawType] || rawType;
};
