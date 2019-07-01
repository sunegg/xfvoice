import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

//  "${PODS_ROOT}/Frameworks/xfvoice/Frameworks"
/// Platform 需要实现的方法：
/// 初始化方法：- init(String appid)
/// 设置讯飞识别参数：- setParameter(Map param)
/// 打开麦克风并开始识别：- start
/// 关闭麦克风并停止识别：- stop
class XFVoice {
  static const MethodChannel _channel = const MethodChannel('xfvoice');

  static final XFVoice shared = XFVoice._();

  XFVoice._();

  Future<void> init({@required String appIdIos, @required String appIdAndroid}) async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('init', appIdIos);
    }
    if (Platform.isAndroid) {
      await _channel.invokeMethod('init', appIdAndroid);
    }

    _channel.setMethodCallHandler((MethodCall call) async {
      print(call.method);
      print(call.arguments.toString());
    });
  }

  Future<void> setParameter(Map<String, dynamic> param) async {
    await _channel.invokeMethod('setParameter', param);
  }

  Future<void> start({XFVoiceListener listener}) async {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onCancel' && listener?.onCancel != null) {
        listener.onCancel();
      }
      if (call.method == 'onBeginOfSpeech' && listener?.onBeginOfSpeech != null) {
        listener.onBeginOfSpeech();
      }
      if (call.method == 'onEndOfSpeech' && listener?.onEndOfSpeech != null) {
        listener.onEndOfSpeech();
      }
      if (call.method == 'onCompleted' && listener?.onCompleted != null) {
        listener.onCompleted(call.arguments[0], call.arguments[1]);
      }
      if (call.method == 'onResults' && listener?.onResults != null) {
        listener.onResults(call.arguments[0], call.arguments[1]);
      }
      if (call.method == 'onVolumeChanged' && listener?.onVolumeChanged != null) {
        listener.onVolumeChanged(call.arguments);
      }
    });
    await _channel.invokeMethod('start');
  }

  Future<void> stop() async {
    await _channel.invokeMethod('stop');
  }
  
  /// 用完记得释放listener
  void clearListener() {
    _channel.setMethodCallHandler(null);
  }
}

/// 讯飞语音识别的回调映射，有flutter来决定处理所有的回调结果，
/// 会更具有灵活性
class XFVoiceListener {
  VoidCallback onCancel;
  VoidCallback onEndOfSpeech;
  VoidCallback onBeginOfSpeech;
  /// error信息构成的key-value map，[filePath]是音频文件路径
  void Function(Map<dynamic, dynamic> error, String filePath) onCompleted;
  void Function(List results, bool isLast) onResults;
  void Function(int volume) onVolumeChanged;

  XFVoiceListener({
    this.onBeginOfSpeech,
    this.onResults,
    this.onVolumeChanged,
    this.onEndOfSpeech,
    this.onCompleted,
    this.onCancel
  });
}