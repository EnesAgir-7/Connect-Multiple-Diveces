import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';

class wifi_connect extends StatefulWidget {
  @override
  _wifi_connectState createState() => _wifi_connectState();
}

class _wifi_connectState extends State<wifi_connect> {
  String _ssid = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String ssid;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ssid = await PluginWifiConnect.ssid ?? '';
    } on PlatformException {
      ssid = 'Failed to get ssid';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _ssid = ssid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Network SSID: $_ssid\n'),
        ),
      ),
    );
  }
}
