package com.fq.flutter_app;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.os.Message;


import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private Handler handler;
  private static final String CHANNEL = "installStateEventChannel";

  @Override
  public void configureFlutterEngine( FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object o, EventChannel.EventSink eventSink) {
          System.out.println("开始监听");
        registerSDCardListener();
        // 每隔一秒数字+1
            handler = new Handler(message -> {
            // 然后把数字发送给 Flutter
            eventSink.success(message.obj);
            return false;
          });

      }

      @Override
      public void onCancel(Object o) {
          System.out.println("取消监听");
          handler.removeMessages(0);
        handler = null;
        unregisterReceiver(apkInstallListener);

      }
    });
  }

  //代码实现添加

  private final BroadcastReceiver apkInstallListener = new BroadcastReceiver() {

    @Override
    public void onReceive(Context context, Intent intent) {
     String packageName = intent.getDataString();
      if (Intent.ACTION_PACKAGE_ADDED.equals(intent.getAction())) {
        System.out.println(packageName + "有应用被添加");


      } else if (Intent.ACTION_PACKAGE_REMOVED.equals(intent.getAction())) {
        System.out.println(packageName + "应用被删除");
         packageName="-"+packageName;

      } else if (Intent.ACTION_PACKAGE_CHANGED.equals(intent.getAction())) {

      } else if (Intent.ACTION_PACKAGE_REPLACED.equals(intent.getAction())) {
        System.out.println(packageName + "应用被替换");

      } else if (Intent.ACTION_PACKAGE_RESTARTED.equals(intent.getAction())) {
        System.out.println(packageName + "有应用被重启");
      } else if (Intent.ACTION_PACKAGE_INSTALL.equals(intent.getAction())) {
        System.out.println(packageName + "有应用被安装");



      }

      Message message = handler.obtainMessage();
      message.obj = packageName;
      handler.sendMessage(message);

    }
  };

  // 注册监听
  private void registerSDCardListener() {
    IntentFilter intentFilter = new IntentFilter(Intent.ACTION_MEDIA_MOUNTED);
    intentFilter.addAction(Intent.ACTION_PACKAGE_ADDED);
    intentFilter.addAction(Intent.ACTION_PACKAGE_REMOVED);
    intentFilter.addAction(Intent.ACTION_PACKAGE_REPLACED);
    intentFilter.addDataScheme("package");
    registerReceiver(apkInstallListener, intentFilter);
  }

  @Override
  protected void onDestroy() {
    super.onDestroy();
    unregisterReceiver(apkInstallListener);
  }
}
