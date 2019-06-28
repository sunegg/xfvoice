import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

/// Platform 需要实现的方法：
/// - init(String appid)
/// - setParameter(Map param)
/// - start
/// - stop
class XFVoice {
  static const MethodChannel _channel = const MethodChannel('xfvoice');

  static final XFVoice shared = XFVoice._();

  final Map<String, XFVoiceListener> _listeners = Map<String, XFVoiceListener>();

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

/**
//IFlySpeechRecognizerDelegate协议实现
//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{}
//识别会话结束返回代理
- (void)onCompleted: (IFlySpeechError *) error{}
//停止录音回调
- (void) onEndOfSpeech{}
//开始录音回调
- (void) onBeginOfSpeech{}
//音量回调函数
- (void) onVolumeChanged: (int)volume{}
//会话取消回调
- (void) onCancel{}
 */

class XFVoiceListener {
  VoidCallback onCancel;
  VoidCallback onEndOfSpeech;
  VoidCallback onBeginOfSpeech;
  void Function(int code, String msg) onCompleted;
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