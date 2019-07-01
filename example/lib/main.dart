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
      onResults: (List<dynamic> results, isLast) {
        if (results.length > 0) {
          final first = results.first;
          if (first is Map) {
            setState(() {
              iflyResultString += first.keys.first as String;
            });
          }
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
