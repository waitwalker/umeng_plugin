#import "UmengPlugin.h"
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>

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
    NSString *appKey = call.arguments[@"key"];
    // UMConfigInstance.secret = call.arguments[@"secret"];

    NSString* channel = call.arguments[@"channel"];
    if (channel == nil || channel.length == 0) {
        channel = @"App Store";
    }
    
    // 初始化
    [UMConfigure initWithAppkey:appKey channel:channel];
      
      result(@"App store");
  } else if ([@"logPageView" isEqualToString:call.method]) {
      [MobClick logPageView:call.arguments[@"name"] seconds:[call.arguments[@"seconds"] intValue]];
    result(nil);
  } else if ([@"beginPageView" isEqualToString:call.method]) {
    [MobClick beginLogPageView:call.arguments[@"name"]];
    result(nil);
  } else if ([@"endPageView" isEqualToString:call.method]) {
    [MobClick endLogPageView:call.arguments[@"name"]];
    result(nil);
  } else if ([@"logEvent" isEqualToString:call.method]) {
    if (call.arguments[@"label"] != [NSNull null])
      [MobClick beginEvent:call.arguments[@"name"] label:call.arguments[@"label"]];
    else
      [MobClick beginEvent:call.arguments[@"name"]];
    result(nil);
  } else if ([@"reportError" isEqualToString:call.method]) {
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)init:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *appKey = call.arguments[@"key"];
    // UMConfigInstance.secret = call.arguments[@"secret"];

    NSString* channel = call.arguments[@"channel"];
    if (channel == nil || channel.length == 0) {
        channel = @"App Store";
    }
    
    // 初始化
    [UMConfigure initWithAppkey:appKey channel:channel];
}

@end
