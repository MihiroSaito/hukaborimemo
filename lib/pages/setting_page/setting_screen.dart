import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hukaborimemo/pages/setting_page/setting_widgets.dart';

class SettingScreen extends HookWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingAppBar(context),
      body: settingContents(context),
    );
  }
}
