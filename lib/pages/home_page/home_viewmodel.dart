import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_widgets.dart';

void showHomeOptionDialog(BuildContext context) {
  showCupertinoDialog(
      context: context,
      builder: (buildContext){
        return homeOptionDialogWidget(buildContext);
      }
  );
}
