#import "XfvoicePlugin.h"
#import <iflyMSC/iflyMSC.h>

static FlutterMethodChannel *_channel = nil;

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
        
    } else if ([@"setParameter" isEqualToString:call.method]) {
        
    } else if ([@"start" isEqualToString:call.method]) {
        
    } else if ([@"stop" isEqualToString:call.method]) {
        [_channel invokeMethod:@"onVolumeChanged" arguments:[NSNumber numberWithInt:10]];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end

