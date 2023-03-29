import 'package:flutter/material.dart';
import 'package:new_project/page/joinSession.dart';
import 'package:new_project/page/startSession.dart';

import 'try/plugin_wifi_connect.dart';
import 'try/wifi_iot.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return startSession();
                  }),
                );
              },
              child: Text("Start Session"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return joinSession();
                  }),
                );
              },
              child: Text("Join Session"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return WifiIoT();
                  }),
                );
              },
              child: Text("Wifi_iot"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return wifi_connect();
                  }),
                );
              },
              child: Text("Wifi_connect"),
            ),
          ],
        ),
      ),
    );
  }
}
