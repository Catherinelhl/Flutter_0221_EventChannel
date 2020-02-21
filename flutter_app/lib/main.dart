import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/install_state_event_channel.dart';

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
  AppInstallStateEventChannel appInstallStateEventChannel = new AppInstallStateEventChannel();
  @override
  void dispose() {
    super.dispose();
    appInstallStateEventChannel?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EventChannel 事件监听--"),
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
                    onPressed: appInstallStateEventChannel?.startListenAppInstallState,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: RaisedButton(
                        child: Text('Cancel EventChannel',
                            style: TextStyle(fontSize: 12)),
                        onPressed: appInstallStateEventChannel?.stopListenAppInstallState,
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("${appInstallStateEventChannel?.allInstalledAPPS?.length}"),
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
