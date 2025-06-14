#!/bin/bash

declare -A localize=(
    # wechat
    ['emoji.gif']='ステッカー.gif'
    # ['收到一条']="["
    # ['${msg.type()}']='${MessageTypeUtils.getTypeName(msg.type() + '')}'
    # ['消息，请在手机上查看']="]"
    # ['消息，请在手机上接收']="]"
    ['收到一条${msg.type()}消息，请在手机上查看']='[${MessageTypeUtils.getTypeName(msg.type() + "")}]'
    ['收到一条${MessageTypeUtils.getTypeName(msg.type() + "")}消息，请在手机上接收']='[${MessageTypeUtils.getTypeName(msg.type() + "")}]'
    ['`收到一条${MessageTypeUtils.getTypeName(msg.type() + "")}消息，请在手机上查看`']='[${MessageTypeUtils.getTypeName(msg.type() + "")}]'
    ['blockquote expandable']='blockquote'
    ['金额']='金額'
    ['转账备注']='メモ'
    ['微信客户端登录成功！']='✅WeChatにログイン成功！'
    ['请扫描二维码登录,第一次登录加载时间较长，请耐心等待']='QRコードをスキャンしてWeChatにログイン'
    ['请求添加您为好友']='からの友人登録リクエスト'
    ['接受']='承認'
    ['所有人']='すべて'
    ['\\n推荐给你一位联系人']='あなたに連絡先を推薦しました'
    # tgbot
    ['temp_file']='ファイル'
    ['文件接收中']=''
    ['使用文件传输助手接收']='ファイル転送で受信'
    ['请先在 bot 中使用 /flogin 指令登录文件传输助手']='ボットで /flogin を使用してファイル転送にログインしてください'
    ['绑定成功']='バインド成功'
    ['创建群组成功']='グループ作成成功'
    ['打开群组 🚀']='グループを開く🚀'
    ['添加成功']='追加成功'
    ['好友请求已过期']='リクエストが期限切れ'
    ['请先登录微信']='WeChatにログインしてください'
    ['发送失败']='送信失敗'
    ['表情转换失败']='絵文字変換に失敗'
    ['`语音']='`音声'
    ['程序设置']='プログラム設定'
    ['仅支持群组中使用']='グループ内でのみ使用可能'
    ['解绑成功']='バインド解除成功'
    ['未查找到联系人']='連絡先が見つかりません'
    ['绑定联系人']='連絡先をバインド'
    ['创建联系人群组']='連絡先のグループを作成'
    ['未查找到群组']='グループが見つかりません'
    ['绑定微信群']='グループをバインド'
    ['创建微信群群组']='WeChatグループのグループを作成する'
    ['当前未绑定联系人或微信群']='連絡先またはグループがバインドされていません'
    ['请先登录 Telegram 客户端，请输入你的 Telegram 账户的手机号码（需要带国家区号，例如：+8613355558888）']='Telegramの電話番号を入力（国際番号付き、例：+8613355558888）'
    ['请输入你的二步验证密码:']='二段階認証コードを入力'
    ['请输入你收到的验证码:']='受け取った確認コードを入力'
    ['Telegram 客户端登录成功！']='✅Telegramにログイン成功！'
    ['`状态']='`状態'
    ['接收消息']='メッセージを受信'
    ['屏蔽消息']='メッセージをブロック'
    ['该群组暂未绑定']='このグループはまだバインドされていません'
    ['是否接收该群组消息']='グループのメッセージ受信'
    ['当前状态']='現在の状態'
    ['转发']='転送'
    ['不转发']='転送しない'
    ['是否转发群组内其他人的消息']='グループ内の他人のメッセージを転送'
    ['添加为好友']='友人に追加'
    ['你好']=''
    ['好友请求已发送']='友人登録リクエストを送信しました'
    ['名片已过期']='連絡先カードが期限切れ'
    ['没有搜索到该用户']='このユーザーは存在しません'
    ['请在 /add 命令后面加上你要添加的联系人的手机号，例如：/add 18888888888']='/addの後に追加したい連絡先の電話番号を入力（例：/add　18888888888）'
    ['该命令无法在群组中使用']='このコマンドはグループ内では使用できません'
    ['已登录，请勿重复登录']='すでにログインしています。再度ログインしないでください'
    ['请回复需要撤回的消息']='撤回したいメッセージを引用'
    ['撤回失败']='撤回失敗'
    ['撤回失败,无法撤回其他人发送的消息']='他人のメッセージを撤回できません'
    ['撤回请求已发送']='撤回リクエストを送信しました'
    # tgcommand
    ["'帮助'"]="'ヘルプ'"
    ['开始']='スタート'
    ["'登录'"]="'ログイン'"
    ['登录文件传输助手接收文件消息']='ファイル転送にログイン'
    ['更新群组头像和名称']='グループ名と写真を更新'
    ['根据手机号添加好友，在后面加上你需要添加用户的手机号']='携帯番号で友人を追加'
    ['是否接收该群组消息']='グループのメッセージ受信'
    ['是否转发群组内其他人的消息']='他人のメッセージを転送'
    ['撤回消息']='メッセージを撤回'
    ['程序设置']='プログラム設定'
    ['查看联系人']='連絡先を表示'
    ['查看微信群']='グループを表示'
    ['获取我的二维码名片']='自分のQRコードを取得'
    ['解绑群组']='グループのバインド解除'   
    # config
    ['媒体质量压缩']='メディア品質圧縮'
    ['文件传输助手接收视频和文件']='ファイル転送で動画とファイルを受信'
    ['接收公众号消息']='公式アカウントのメッセージを受信'
    ['微信emoji是否以图片链接显示']='WeChatの絵文字を画像リンクに変換'
    ['转发自己在微信发送的消息']='自分が送信したメッセージを転送'
    ['启动时同步群组信息']='起動するとグループを同期'
    ['开启']='⭕️オン'
    ['关闭']='❌オフ'
    # msgtype
    ['未知类型']='未知タイプ'
    ['文件开始']='ファイル開始'
    ['文件发送结束']='ファイル送信終了'
    ["'语音'"]="'音声'"
    ["'名片'"]="'連絡先カード'"
    ['表情']='ステッカー'
    ['图片']='画像'
    ['文本']='テキスト'
    ["'视频'"]="'動画'"
    ['群邀请']='グループ招待'
    ['小程序']='ミニプログラム'
    # ["'app'"]='\'アプリ\''
    ['公众号链接']='公式アカウントリンク'
    ['添加好友通知']='友人追加通知'
    ['引用']='引用'
    ['转账']='送金'
    ['红包']='ラッキーマネー'
    ['视频号']='チャンネル'
    ['撤回']='撤回'
    ['拍一拍']='軽く叩い'
    ["'位置'"]="'場所'"
    ['微信团队']='WeChatチームメッセージ'
    ['朋友圈更新']='モーメント更新'
    ['聊天记录']='チャット履歴'
    ['视频/语音']='ビデオ/音声通話'
    ['实时位置共享']='リアルタイム場所'
)
