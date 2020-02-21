

import 'dart:async';

import 'package:flutter/services.dart';

class AppInstallStateEventChannel{
  // 创建 EventChannel
  static const stream =
  const EventChannel("installStateEventChannel");

  List<String> allInstalledAPPS = List();

  StreamSubscription _listenInstallStateSubscription;

  ///开始监听应用的安装状态
  void startListenAppInstallState() {
    if (_listenInstallStateSubscription == null)
      // 监听 EventChannel 流, 会触发 Native onListen回调
      _listenInstallStateSubscription = stream.receiveBroadcastStream().listen(updateAllInstalledApp,onError: _onError);
  }

  ///停止监听对应用安装过程的监听
  void stopListenAppInstallState() {
    _listenInstallStateSubscription?.cancel();
    _listenInstallStateSubscription = null;
     allInstalledAPPS.clear();
  }

  ///更新当前检测到的所有已经安装的APP
  void updateAllInstalledApp(dynamic package) {
    print("${package is Map<bool,String>}--------$package");
    if(package != null ){
      String singlePackage =package  ;
      if(singlePackage.startsWith("-")){
        singlePackage =singlePackage.replaceAll("-", "");
        print('Flutter:${singlePackage};被卸载了');

      }else{
        print('Flutter:${singlePackage};被安装了');

      }

      allInstalledAPPS.add(singlePackage);
      print('------length:${allInstalledAPPS.length}');
      //TODO  通知事件进行刷新

    }
  }

  void _onError(Object object){
    print('监听异常${object.toString()}');

  }
  void dispose(){
    _listenInstallStateSubscription?.cancel();
    _listenInstallStateSubscription = null;
  }
}