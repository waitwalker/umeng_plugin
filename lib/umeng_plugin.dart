import 'dart:async';
import 'package:flutter/services.dart';

class Policy {
  static final int REALTIME = 0;
  static final int BATCH = 1;
  static final int SEND_INTERVAL = 6;
  static final int SMART_POLICY = 8;
}


class UmengPlugin {
  static const MethodChannel _channel =
      const MethodChannel('umeng_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> init(String key,
      {int? policy,
        bool? reportCrash,
        bool? encrypt,
        String? channel,
        double? interval,
        bool? logEnable}) {
    Map<String, dynamic> args = {"key": key};

    args["channel"] = channel;
    if (policy != null) args["policy"] = policy;
    if (reportCrash != null) args["reportCrash"] = reportCrash;
    if (encrypt != null) args["encrypt"] = encrypt;
    if (interval != null) args["interval"] = interval;
    if (logEnable != null) args["logEnable"] = logEnable;
    if (logEnable != null) args["logEnable"] = logEnable;

    _channel.invokeMethod("init", args);
    return new Future.value(true);
  }

  // page view
  static Future<dynamic> logPageView(String name, int seconds) {
    return _channel.invokeMethod("logPageView", {"name": name, "seconds": seconds});
  }

  static Future<dynamic> beginPageView(String name) {
    return _channel.invokeMethod("beginPageView", {"name": name});
  }

  static Future<dynamic> endPageView(String name) {
    return _channel.invokeMethod("endPageView", {"name": name});
  }

  // event
  static Future<dynamic> logEvent(String name, {String? label}) {
    return _channel.invokeMethod("logEvent", {"name": name, "label": label});
  }

  static Future<dynamic> reportError(String error) {
    return _channel.invokeMethod("reportError", {"error": error});
  }
}
