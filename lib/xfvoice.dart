import 'dart:async';

import 'package:flutter/services.dart';

class Xfvoice {
  static const MethodChannel _channel =
      const MethodChannel('xfvoice');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
