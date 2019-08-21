import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:xfvoice/xfvoice.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  String voiceMsg = '暂无数据';
  String iflyResultString = '按下方块说话';

  XFJsonResult xfResult;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

   Future<void> initPlatformState() async {
    final voice = XFVoice.shared;
    // 请替换成你的appid
    voice.init(appIdIos: 'xxxxxxx', appIdAndroid: 'xxxxxxx');
    final param = new XFVoiceParam();
    param.domain = 'iat';
    // param.asr_ptt = '0';
    param.asr_audio_path = 'xme.pcm';
    param.result_type = 'json';
    final map = param.toMap();
    map['dwa'] = 'wpgs';
    voice.setParameter(map);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '测试的demo',
      home: Scaffold(
        appBar: AppBar(
          title: new Text('测试demo'),
        ),
        body: Center(
          child: GestureDetector(
            child: Container(
              child: Text(iflyResultString),
              width: 300.0,
              height: 300.0,
              color: Colors.blueAccent,
            ),
            onTapDown: (d) {
              setState(() {
                voiceMsg = '按下';
              });
              _recongize();
            },
            onTapUp: (d) {
              // _recongizeOver();
            },
          ),
        )
      ),
    );
  }

  void _recongize() {
    final listen = XFVoiceListener(
      onVolumeChanged: (volume) {
      },
      onBeginOfSpeech: () {
        xfResult = null;
      },
      onResults: (String result, isLast) {
        if (xfResult == null) {
          xfResult = XFJsonResult(result);
        } else {
          final another = XFJsonResult(result);
          xfResult.mix(another);
        }
        if (result.length > 0) {
          setState(() {
            iflyResultString = xfResult.resultText();
          });
        }
      },
      onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
        setState(() {
          
        });
      }
    );
    XFVoice.shared.start(listener: listen);
  }

  void _recongizeOver() {
    XFVoice.shared.stop();
  }
}
