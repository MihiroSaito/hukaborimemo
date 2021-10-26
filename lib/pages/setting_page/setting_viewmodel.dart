
void settingFunctions({required String settingTitle}) {

  switch(settingTitle){
    case 'パスワード設定':
      //todo: パスワード設定へ
      break;
    case 'テーマ変更':
      //todo: テーマ変更へ
      break;
    case '使い方':
      //todo: 使い方へ
      break;
    case 'お問い合わせ・ご意見':
      //todo: URLを使ってGoogleFormに飛ばす
      break;
    case 'アプリを評価する':
      //todo: ストアIDを使って各ストアのレビューへ
      break;
    case '利用規約':
      //todo: 利用規約へ
      break;
    case 'プライバシーポリシー':
      //todo: プライバシーポリシーへ
      break;
    case 'Licenses':
      //todo: ライセンスへ
      break;
    default:
      throw Exception('SettingClass.settingMenusに定義されていないページがありました。'
          '（おそらく設定の項目を追加したけどここでの処理の記述を忘れている。）');
  }
}
