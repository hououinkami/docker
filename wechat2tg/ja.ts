const zh = {
    command: {
        aad: {
            success: '追加成功',
            fail: '追加失敗',
            exist: 'すでに存在しています',
            noUser: 'ユーザーがいません',
        },
        description: {
            help: 'マニュアル',
            start: '開始',
            login: 'QRコードをスキャンしてログイン',
            user: 'ユーザーリスト',
            room: 'グループリスト',
            recent: '最近の連絡先',
            settings: 'プログラム設定',
            check: 'WeChatログイン状態を確認',
            bind: 'グループのバインド状態を確認',
            unbind: 'グループのバインドを解除',
            gs: 'メッセージ転送',
            source: 'オリジナルファイルを取得するには、ファイルメッセージに返信',
            aad: '転送を許可する対象を追加します。複数の場合はスペースで区切ります。ボットで実行するとすべてのグループに追加されます',
            als: '転送を許可する対象のリストを表示',
            arm: '転送を許可する対象を削除',
            order: '公式アカウントのショートカットコマンドを設定',
            cgdata: 'グループのアイコンと名前を設定（管理者権限が必要）',
            rcc: '現在の連絡先を再読み込み（グループチャットでは現在のバインド済みユーザーを更新。ボットでは複数の名前をスペースで区切ります。指定がない場合はすべてのユーザーを更新⚠️ 非常に遅くなる可能性あり）',
            reset: 'キャッシュをクリアして再ログイン',
            stop: 'WeChatクライアントを停止（再ログインが必要）',
            autocg: '自動グループ作成モード。API設定とTelegramユーザークライアントでのログインが必要',
            lang: '言語を設定',
        },
        helpText: `**WeChatメッセージ転送ボットへようこそ**

[本プロジェクト](https://github.com/finalpi/wechat2tg)はWechatyとwechat4uプロジェクトをベースに開発されました。
**本プロジェクトは技術研究と学習を目的としており、不正使用は禁止されています。**

1\\. /start または /login コマンドでWeChatクライアントを起動し、/login コマンドでQRコードをスキャンしてログインします。
2\\. /user または /room コマンドで連絡先やグループを検索します（名前や備考を入力可能、例：「/user 張」で「張」が含まれるユーザーを検索）。
3\\. ログイン後、連絡先リストの読み込みを待つ必要があります。
4\\. /settings 設定を開きます。
5\\. 現在返信中のユーザーまたはグループがピンされます。
6\\. 転送されたメッセージに返信すると、該当の人またはグループに直接転送されます（返信した返信のメッセージには対応していません。また、現在返信中のユーザーは変更されません）。
7\\. 使用されるプロトコルの性質上、**アカウントがブロックされる可能性**があります（今のところ経験はありません）。使用前にご注意ください。
8\\. 詳細はGitHubリポジトリのREADMEをご参照ください。`,
        startText: '/login を入力してログインしてください。または /help を入力してヘルプを確認してください。\n注意: /login を実行した後、このボットの所有者となります。',
        settingsText: 'プログラム設定:',
        langText: '言語設定:',
        resetText: 'リセット成功',
        autocg: {
            configApi: 'まずAPI_IDとAPI_HASHを設定してください',
            modelAutoCreate: '自動グループ作成モード({0})',
            inputVerificationCode: '受け取った確認コードを入力してください:{0}'
        },
        check: {
            onLine: 'WeChatがオンラインです',
            offLine: 'WeChatがオフラインです',
        },
        settings: {},
        cgdata: {
            notBind: '現在、連絡先またはグループがバインドされていません',
            notAdmin: 'ボットはこのグループの管理者ではありません',
        },
        bind: {
            currentBindUser: '現在バインドされている連絡先:',
            currentBindGroup: '現在バインドされているグループ:',
            noBinding: '現在、連絡先やグループはバインドされていません',
        },
        unbindText: 'バインド解除成功',
        login: {
            fail: 'すでにログイン済み、またはログインに失敗しました。状態を確認してください',
        },
        stop: {
            success: '停止成功。/login コマンドで再起動してください',
            fail: '停止失敗',
        },
        room: {
            notFound: 'グループが見つかりませんでした',
            plzSelect: 'グループを選択してください（クリックで返信）',
        },
        user: {
            onLogin: 'ログイン中、しばらくお待ちください...',
            onLoading: '連絡先リストを読み込中、しばらくお待ちください...',
            plzSelect: '連絡先を選択してください（クリックで返信）',
            notFound: '該当ユーザーが見つかりませんでした:',
            individual: '友人',
            official: '公式アカウント',
            plzSelectType: '種類を選択してください:',
        },
        source: {
            hint: 'ファイルメッセージに返信して /source コマンドを使用してください',
            needFile: 'ファイルメッセージに返信してください',
            fail: 'オリジナル画像の取得に失敗しました'
        },
        order: {
            addOrder: 'コマンドを追加',
            removeOrder: 'コマンドを削除',
            sendOrder: 'コマンドを送信',
            addOrderHint: '追加するコマンドの公式アカウントを選択してください:',
            removeOrderHint: '削除するコマンドを選択してください',
            noRepeat: 'コマンド名を入力してください。他のコマンド名と重複しない必要があります',
            sendSuccess: 'コマンド送信成功',
            removeSuccess: 'コマンド削除成功',
            nameExist: 'コマンド設定失敗。コマンド名が既に存在します',
            plzInput: 'コマンドを入力してください',
            addSuccess: 'コマンド追加成功',
        },
        setting: {
            messageMode: 'メッセージモード切り替え({0})',
            messageFallback: '送信成功通知({0})',
            autoSwitchContact: '連絡先の自動切り替え({0})',
            receiveOfficial: '公式アカウントメッセージを受信({0})',
            blockEmoticon: 'ステッカーをブロック({0})',
            autoTranscript: '自動音声文字変換({0})',
            forwardSelf: 'WeChatで送信した自分のメッセージを転送({0})',
            mediaQualityCompression: 'メディアの品質圧縮({0})',
            blackMode: 'ブラックリストモード',
            whiteMode: 'ホワイトリストモード',
            whiteGroup: 'ホワイトリストグループ',
            blackGroup: 'ブラックリストグループ',
        },
        recent: {
            noUsers: '最近の連絡先が空です',
            plzSelect: '連絡先を選択してください（クリックで返信）',
        },
    },
    common: {
        gs: 'メッセージ転送 {0}',
        open: 'オン',
        close: 'オフ',
        sendSuccess: '送信成功',
        sendFail: '送信失敗',
        sendFailNoBind: '送信失敗。連絡先またはグループがバインドされていません。/room または /user コマンドを使用してバインドしてください',
        plzLoginWeChat: 'WeChatにログインしてください',
        clickChange: 'クリックして切り替え',
        onlyInGroup: 'このコマンドはグループ内でのみ使用可能です',
        nextPage: '次のページ',
        prevPage: '前のページ',
        scanLogin: 'QRコードをスキャンしてログインしてください:',
        accept: '承認',
        error: 'エラー',
        unknown: '不明',
        large: '大きすぎます',
        setSuccess: '設定成功',
        notFoundGroup: '該当グループが見つかりませんでした。グループ名を確認してください',
        chooseGroup: 'グループを選択してください（クリックして追加）:',
        blackListRemove: 'ブラックリスト（クリックして削除）:',
        loginHint: '携帯番号を入力してください（国番号を含めてください。例:+8613355558888）',
        messageExpire: 'メッセージが期限切れです',
        failReceive: '再受信失敗',
        transFail: 'ファイル変換失敗',
        sendFailMsg: '送信失敗, {0}',
        sendFailFailMsg: 'ファイル送信失敗, {0}',
        saveOrgFileError: 'オリジナルファイルの保存に失敗しました',
        emptyFile: 'ファイルが空です',
        fileLarge: 'ファイルが大きすぎます（Telegramの制限は20MBです）',
        tgLoginSuccess: 'Telegramのログイン成功！',
        tgLoginInputPassword: '2段階認証パスワードを入力してください:',
        tgLoginVerifyCode: '受信した認証コードを入力してください:_ _ _ _ _\n',
        emptyReply: '返信先なし',
        createFolderFail: 'Telegramフォルダー作成失敗',
        addGroupToFolderFail: 'グループをフォルダーに追加するのに失敗しました',
        tooManyRequests: 'リクエストが多すぎます。{0}秒後に再試行してください',
        reReceive: '再受信',
        setTencentCloud: 'まずTencent CloudのsecretIdとsecretKeyを設定してください',
    },
    wechat: {
        requestAddFriend: '友達追加のリクエスト:',
        unknownUser: '不明なユーザー:',
        plzViewOnPhone: '携帯でご確認ください',
        get: '受信',
        getOne: '1件を受信',
        roomInvite: 'グループチャットに招待されました（ユーザー名とグループ名を取得できません）',
        loginOutDate: 'ログイン状態が期限切れです。ボットを再起動してください',
        loginSuccess: 'WeChatログイン成功！',
        loginFail: 'WeChatログイン失敗！',
        loadingMembers: '連絡先を読み込んでいます...',
        me: '私',
        audioOrVideo: '音声/ビデオ通話',
        forwardFail: '転送失敗',
        recallMessage: 'メッセージの撤回を完了しました',
        friendExpired: '友達申請が期限切れです！',
        addSuccess: '追加成功！',
        logoutSuccess: 'ログアウト成功！',
        logoutFail: 'ログアウト失敗！',
        user: 'ユーザー',
        room: 'グループ',
        official: '公式アカウント',
        all: 'すべて',
        messageType: {
            unknown: '❔不明',
            text: '📝テキスト',
            card: '📇名刺',
            file: '📄ファイル',
            image: '🖼️画像',
            voice: '🔉音声',
            video: '🎬動画',
            emoticon: '😎ステッカー',
            miniProgram: 'ミニプログラム',
            redPacket: '🧧ラッキーマネー',
            url: '🔗リンク',
            transfer: '💴送金',
            recalled: '㊙️撤回したメッセージ',
            groupNote: '📣グループ通知',
            chatHistory: '💬チャット履歴',
            post: '📬投稿',
            location: '📍位置',
            setMsg: '💬チャット履歴',
        },
        contactFinished: '連絡先の読み込みが完了しました',
        contactFailed: '連絡先の読み込みに失敗しました',
        fileReceivingFailed: '❌ファイル受信失敗',
        receivingFile: '📄ファイル受信中...',
        transcripting: '音声から文字への変換中...',
        audioTranscriptFailed: '音声から文字への変換に失敗',
    },
    telegram: {
        btn: {
            whiteListManager: 'ホワイトリスト管理:',
            addWhiteList: 'ホワイトリストを追加',
            whiteList: 'ホワイトリスト',
            blackListManager: 'ブラックリスト管理:',
            addBlackList: 'ブラックリストを追加',
            blackList: 'ブラックリスト',
        },
        msg: {
            emptyWhiteList: 'ホワイトリストが空です',
            removeWhiteList: 'ホワイトリスト（クリックして削除）:',
            emptyBlackList: 'ブラックリストが空です',
            removeSuccess: '削除成功',
            addListName: 'リストに追加するグループ名を入力してください',
            updateAliasSuccess: 'コメント設定成功',
            updateAliasFail: 'コメント設定失敗',
            recallSuccess: '撤回成功',
            recallFail: '撤回失敗',
            recallNotDone: 'このメッセージはすでに撤回されているか、まだ送信が完了していないか、または時間切れです',
            noContacts: '連絡先がありません',
            selectContacts: '連絡先を選択してください（クリックで返信）:',
            currentReply: '現在の返信先{0}:',
        }
    }
};

export default zh;
