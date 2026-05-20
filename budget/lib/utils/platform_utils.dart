import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:budget/struct/settings.dart';

enum PlatformOS {
  isIOS,
  isAndroid,
  web,
}

PlatformOS? getPlatform({bool ignoreEmulation = false}) {
  if (appStateSettings["iOSEmulate"] == true && ignoreEmulation == false) {
    return PlatformOS.isIOS;
  } else if (kIsWeb) {
    return PlatformOS.web;
  } else if (Platform.isIOS) {
    return PlatformOS.isIOS;
  } else if (Platform.isAndroid) {
    return PlatformOS.isAndroid;
  }
  return null;
}
