import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 创建 EventChannel
  static const stream =
      const EventChannel("installStateEventChannel");

  List<String> allInstalledAPPS = List();

  StreamSubscription _listenInstallStateSubscription;

  ///开始监听应用的安装状态
  void _startListenAppInstallState() {
    if (_listenInstallStateSubscription == null)
      // 监听 EventChannel 流, 会触发 Native onListen回调
      _listenInstallStateSubscription = stream.receiveBroadcastStream().listen(_updateAllInstalledApp,onError: _onError);
  }

  ///停止监听对应用安装过程的监听
  void _stopListenAppInstallState() {
    _listenInstallStateSubscription?.cancel();
    _listenInstallStateSubscription = null;
    setState(() => allInstalledAPPS.clear());
  }

  ///更新当前检测到的所有已经安装的APP
  void _updateAllInstalledApp(dynamic package) {
    print("${package is Map<bool,String>}--------$package");
    if(package != null ){
      String singlePackage =package  ;
      if(singlePackage.startsWith("-")){
        singlePackage =singlePackage.replaceAll("-", "");
        print('Flutter:${singlePackage};被卸载了');

      }else{
        print('Flutter:${singlePackage};被安装了');

      }

      setState(() =>  allInstalledAPPS.add(singlePackage));
      print('------length:${allInstalledAPPS.length}');

    }
  }

  void _onError(Object object){
    print('监听异常${object.toString()}');

  }
  @override
  void dispose() {
    super.dispose();
    _listenInstallStateSubscription?.cancel();
    _listenInstallStateSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EventChannel 事件监听"),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, top: 10),
        child: Center(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Start EventChannel',
                        style: TextStyle(fontSize: 12)),
                    onPressed: _startListenAppInstallState,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: RaisedButton(
                        child: Text('Cancel EventChannel',
                            style: TextStyle(fontSize: 12)),
                        onPressed: _stopListenAppInstallState,
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("${allInstalledAPPS.length}"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
