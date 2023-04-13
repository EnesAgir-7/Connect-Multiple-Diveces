import 'package:flutter/material.dart';
import 'package:new_app/pages/wifi_connect.dart';

class WifiConnectPage extends StatefulWidget {
  @override
  _WifiConnectPageState createState() => _WifiConnectPageState();
}

class _WifiConnectPageState extends State<WifiConnectPage> {
  bool _isWifiEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wifi Connect'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                _isWifiEnabled = await WifiConnect.isEnabled;
                setState(() {});
              },
              child: Text("Check if WiFi is enabled"),
            ),
            SizedBox(height: 20),
            Text(
              _isWifiEnabled ? 'WiFi is enabled' : 'WiFi is disabled',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
