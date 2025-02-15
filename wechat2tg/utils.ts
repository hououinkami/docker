export const translateMessageType = (rawType: string | number): string => {
  const typeMapping: { [key: string]: string } = {
    'link': '🔗リンク',
    'video_account': '🎬チャンネル',
    'mini_app': '🧿ミニプログラム',
    'pat': '✋軽く叩い',
    'unknown': '❓不明',
    'voice': '🎙音声',
    'contact': '👤連絡先',
    'emoji': '😄ステッカー',
    'image': '🖼画像',
    'text': '📝テキスト',
    'video': '🎬動画',
    'room_invitation': '👥グループ招待',
    'app_msg': '📥アプリメッセージ',
    'add_friend': '👤友達追加通知',
    'quote': '🔖引用',
    'transfer': '💴送金',
    'red_packet': '🧧ラッキーマネー',
    'revoke': '♻️撤回',
    'location': '📍場所',
    'function_msg': '📥公式メッセージ',
    'new_monment_timeline': '🔄モーメンツ更新',
    'chat_histroy': '💬チャット履歴',
    'voip': '📥VOIPメッセージ',
    'real_time_location': '📍リアルタイム場所'
  };
  const key = typeof rawType === 'number' ? String(rawType) : rawType;
  return typeMapping[key] || key;
};
