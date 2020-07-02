package com.etiantian.online.umeng_plugin;

import android.content.Context;

import androidx.annotation.NonNull;

import com.umeng.analytics.*;
import com.umeng.commonsdk.*;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** UmengPlugin */
public class UmengPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;

  Context contextO;
  static Context contextR;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "umeng_plugin");
    channel.setMethodCallHandler(this);
    contextO = flutterPluginBinding.getApplicationContext();
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "umeng_plugin");
    channel.setMethodCallHandler(new UmengPlugin());
    contextR = registrar.activeContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("init")) {
      init(call, result);
    } else if (call.method.equals("beginPageView")) {
      MobclickAgent.onPageStart(((String) call.argument("name")).intern());
      if (contextO != null) {
        MobclickAgent.onResume(contextO);
      }

      if (contextR != null) {
        MobclickAgent.onResume(contextR);
      }
      result.success(null);
    } else if (call.method.equals("endPageView")) {
      MobclickAgent.onPageEnd(((String) call.argument("name")).intern());

      if (contextO != null) {
        MobclickAgent.onPause(contextO);
      }

      if (contextR != null) {
        MobclickAgent.onPause(contextR);
      }
      result.success(null);
    } else if (call.method.equals("logEvent")) {
      if (contextO != null) {
        MobclickAgent.onEvent(contextO, ((String) call.argument("name")).intern(),
                ((String) call.argument("label")).intern());
      }

      if (contextR != null) {
        MobclickAgent.onEvent(contextR, ((String) call.argument("name")).intern(),
                ((String) call.argument("label")).intern());
      }

      result.success(null);
    } else if (call.method.equals("reportError")) {
      if (contextO != null) {
        MobclickAgent.reportError(contextO, (String) call.argument("error"));
      }

      if (contextR != null) {
        MobclickAgent.reportError(contextR, (String) call.argument("error"));
      }
      result.success(null);
    } else {
      result.notImplemented();
    }
  }

  public void init(MethodCall call, Result result) {
    Object logEnable = call.argument("logEnable");
    Object encrypt = call.argument("encrypt");
    String channel = call.argument("channel");
    if (logEnable != null) {
      UMConfigure.setLogEnabled((Boolean) logEnable);
    }

    if (contextO != null) {
      UMConfigure.init(contextO, (String) call.argument("key"), channel, UMConfigure.DEVICE_TYPE_PHONE, null);
    }

    if (contextR != null) {
      UMConfigure.init(contextR, (String) call.argument("key"), channel, UMConfigure.DEVICE_TYPE_PHONE, null);
    }

    if (encrypt != null) {
      UMConfigure.setEncryptEnabled((Boolean) encrypt);
    }
    result.success(true);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
