import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void alertVibration() {
  if (Platform.isIOS) {
    HapticFeedback.heavyImpact();
    Timer(Duration(milliseconds: 130), () {
      HapticFeedback.heavyImpact();
    });
  }
}

void launchURL(String _url) async {
  if (await canLaunch(_url)) {
    await launch(_url);
  } else {
    throw 'Could not launch $_url';
  }
}
