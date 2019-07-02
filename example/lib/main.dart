import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:xfvoice/xfvoice.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String iflyResultString = '按下开始识别，松手结束识别';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final voice = XFVoice.shared;
    voice.init(appIdIos: '5d133a41', appIdAndroid: '5d199f2d');
    final param = new XFVoiceParam();
    param.domain = 'iat';
    param.asr_ptt = '0';
    param.asr_audio_path = 'xme.pcm';
    param.result_type = 'plain';
    voice.setParameter(param.toMap());
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
            child: Text(iflyResultString),
            onTapDown: onTapDown,
            onTapUp: onTapUp,
          ),
        ),
      ),
    );
  }

  onTapDown(TapDownDetails detail) {
    iflyResultString = '';
    final listen = XFVoiceListener(
      onVolumeChanged: (volume) {
        print('$volume');
      },
      onResults: (String result, isLast) {
        if (result.length > 0) {
          setState(() {
            iflyResultString += result;
          });
        }
      },
      onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
        setState(() {
          iflyResultString += '\n$filePath';
        });
      }
    );
    XFVoice.shared.start(listener: listen);
  }

  onTapUp(TapUpDetails detail) {
    XFVoice.shared.stop();
  }
}
