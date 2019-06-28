import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xfvoice/xfvoice.dart';

void main() {
  const MethodChannel channel = MethodChannel('xfvoice');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Xfvoice.platformVersion, '42');
  });
}
