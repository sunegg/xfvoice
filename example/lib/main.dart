import 'package:flutter/material.dart';
import 'dart:async';

import 'package:xfvoice/xfvoice.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final voice = XFVoice.shared;
    voice.init(appIdIos: '5d133a41', appIdAndroid: '5d133aae');
    voice.setParameter({'domain': 'iat', 'asr_ptt' : 0, 'asr_audio_path': 'xme.pcm', 'result_type': 'plain'});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(
            child: Text('按下开始识别，松手结束识别'),
            onTapDown: onTapDown,
            onTapUp: onTapUp,
          ),
        ),
      ),
    );
  }

  onTapDown(TapDownDetails detail) {
    XFVoice.shared.start();
  }

  onTapUp(TapUpDetails detail) {
    XFVoice.shared.stop();
  }
}
