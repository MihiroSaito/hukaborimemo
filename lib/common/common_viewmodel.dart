import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

void alertVibration() {
  if (Platform.isIOS) {
    HapticFeedback.heavyImpact();
    Timer(Duration(milliseconds: 130), () {
      HapticFeedback.heavyImpact();
    });
  }
}
