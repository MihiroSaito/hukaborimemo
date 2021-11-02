
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

Future<void> settingFunctions({
  required String settingTitle,
  required BuildContext context
}) async {

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
      final info = await PackageInfo.fromPlatform();
      showLicensePage(
        context: context,
        applicationName: info.appName,
        applicationVersion: info.version,
      );
      break;
    default:
      throw Exception('SettingClass.settingMenusに定義されていないページがありました。'
          '（おそらく設定の項目を追加したけどここでの処理の記述を忘れている。）');
  }
}
