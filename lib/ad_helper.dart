//import 'dart:core';

import 'globals.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (isAndroid && !isWeb) {
      return 'ca-app-pub-4860380403931913/9133315995';
    }
    // else if (Platform.isIOS) {
    //   return 'ca-app-pub-3940256099942544/2934735716';
    // }
    throw UnsupportedError("Unsupported platform");
  }
}
