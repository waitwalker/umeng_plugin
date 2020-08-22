#import "UmengPlugin.h"


@implementation UmengPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"umeng_plugin"
            binaryMessenger:[registrar messenger]];
  UmengPlugin* instance = [[UmengPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"init" isEqualToString:call.method]) {
     result(@"App store");
  } else if ([@"logPageView" isEqualToString:call.method]) {
    result(nil);
  } else if ([@"beginPageView" isEqualToString:call.method]) {
    result(nil);
  } else if ([@"endPageView" isEqualToString:call.method]) {
    result(nil);
  } else if ([@"logEvent" isEqualToString:call.method]) {
    result(nil);
  } else if ([@"reportError" isEqualToString:call.method]) {
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
