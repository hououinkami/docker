export const translateMessageType = (rawType: string): string => {
  const typeMapping: { [key: string]: string } = {
    'link': '🔗リンク',
    'video_account': 'チャンネル',
    'mini_app': 'ミニプログラム',
    'pat': '軽く叩い',
    'unknown': '不明',
    'voice': '音声',
    'contact': '連絡先',
    'emoji': 'ステッカー',
    'image': '画像',
    'text': 'テキスト',
    'video': '動画',
    'room_invitation': '群邀请',
    'app_msg': '軽く',
    'add_friend': '添加好友通知',
    'quote': '軽く',
    'transfer': '軽く',
    'red_packet': '軽く',
    'revoke': '軽く',
    'location': '軽く',
    'function_msg': '軽く',
    'new_monment_timeline': '軽く',
    'chat_histroy': '軽く',
    'voip': '軽く',
    'real_time_location': '軽く'
  };
  return typeMapping[rawType] || rawType;
};
