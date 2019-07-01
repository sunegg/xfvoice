#import "XfvoicePlugin.h"
#import <iflyMSC/iflyMSC.h>

static FlutterMethodChannel *_channel = nil;

@interface XfvoicePlugin () <IFlySpeechRecognizerDelegate>

@property (nonatomic, strong) NSNumber *aaa;

@end

@implementation XfvoicePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"xfvoice"
                                     binaryMessenger:[registrar messenger]];
    XfvoicePlugin* instance = [[XfvoicePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    _channel = channel;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog([call.method description]);
    if (call.arguments != nil) {
        NSLog([call.arguments description]);
    }
    if ([@"init" isEqualToString:call.method]) {
        [self iflyInit:call.arguments];
    } else if ([@"setParameter" isEqualToString:call.method]) {
        [self setParameter:call.arguments];
    } else if ([@"start" isEqualToString:call.method]) {
        [self start];
    } else if ([@"stop" isEqualToString:call.method]) {
        [self stop];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - Bridge Actions

- (void)iflyInit:(NSString *)appId {
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", appId];
    [IFlySpeechUtility createUtility:initString];
    [[IFlySpeechRecognizer sharedInstance] setDelegate:self];
}

- (void)setParameter:(NSDictionary *)param {
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [[IFlySpeechRecognizer sharedInstance] setParameter:obj forKey:key];
    }];
}

- (void)start {
    if ([[IFlySpeechRecognizer sharedInstance] isListening]) {
        return;
    }
    [[IFlySpeechRecognizer sharedInstance] startListening];
}

- (void)stop {
    [[IFlySpeechRecognizer sharedInstance] stopListening];
}

#pragma mark - iFly delegate

- (void)onCompleted:(IFlySpeechError *)errorCode {
    NSDictionary *dic = @{@"code": @(errorCode.errorCode),
                          @"type": @(errorCode.errorType),
                          @"desc": errorCode.errorDesc
                          };
    [_channel invokeMethod:@"onCompleted" arguments:@[dic, @"filePath"]];
}

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast {
    results = (results == nil) ? @[] : results;
    [_channel invokeMethod:@"onResults" arguments:@[results, @(isLast)]];
}

- (void)onVolumeChanged:(int)volume {
    [_channel invokeMethod:@"onVolumeChanged" arguments:@(volume)];
}

- (void)onBeginOfSpeech {
    [_channel invokeMethod:@"onBeginOfSpeech" arguments:NULL];
}

- (void)onEndOfSpeech {
    [_channel invokeMethod:@"onEndOfSpeech" arguments:NULL];
}

- (void)onCancel {
    [_channel invokeMethod:@"onCancel" arguments:NULL];
}

@end

