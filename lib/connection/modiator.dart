import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

class CreateSessionPage extends StatefulWidget {
  @override
  _CreateSessionPageState createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  late ServerSocket server;
  List<Socket> clients = [];

  @override
  void initState() {
    super.initState();
    _startServer();
  }

  @override
  void dispose() {
    super.dispose();
    _stopServer();
  }

  Future<void> _startServer() async {
    server = await ServerSocket.bind('localhost', 12345);
    server.listen((client) {
      setState(() {
        clients.add(client);
      });
      // client.transform(utf8.decoder).listen((data) {
      //   _handleMessage(data);
      // });
    });
  }

  void _stopServer() {
    server.close();
    clients.forEach((client) => client.close());
  }

  void _handleMessage(String message) {
    print('Received message: $message');
    clients.forEach((client) => client.write(message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Session ID:',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '${server.address.host}:${server.port}',
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32.0),
            Text(
              'Waiting for clients...',
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}

class JoinSessionPage extends StatefulWidget {
  @override
  _JoinSessionPageState createState() => _JoinSessionPageState();
}

class _JoinSessionPageState extends State<JoinSessionPage> {
  late Socket socket;
  String message = '';

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  @override
  void dispose() {
    super.dispose();
    _disconnectFromServer();
  }

  Future<void> _connectToServer() async {
    try {
      socket = await Socket.connect('localhost', 12345);
      // socket.transform(utf8.decoder).listen((data) {
      //   setState(() {
      //     message = data;
      //   });
      // });
    } catch (e) {
      print('Error connecting to server: $e');
    }
  }

  void _disconnectFromServer() {
    socket.close();
  }

  void _sendMessage(String message) {
    socket.write(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Session ID:',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'localhost:12345',
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32.0),
            Text(
              'Connected to server: ${socket.remoteAddress.address}:${socket.remotePort}',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 32.0),
            Text(
              'Message:',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            Text(
              message,
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                _sendMessage('Hello from client!');
              },
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}

class Session {
  final Socket socket;
  late StreamSubscription subscription;

  Session(this.socket) {
    subscription = socket.transform(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        _handleMessage(data);
      },
    )).listen((_) {});
  }

  void sendMessage(String message) {
    socket.write(message);
  }

  void _handleMessage(dynamic message) {
    print('Received message: $message');
  }

  void dispose() {
    subscription.cancel();
    socket.close();
  }
}

void main() async {
  final server = await ServerSocket.bind('localhost', 12345);
  print('Server started on port: ${server.port}');

  final sessions = <Session>[];

  server.listen((client) {
    final session = Session(client);
    sessions.add(session);
    print('Client connected: ${client.remoteAddress}:${client.remotePort}');
    client.write('You have joined the session!');

    session.sendMessage('New client connected: ${client.remoteAddress}:${client.remotePort}');

    client.transform(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sessions.forEach((s) {
          //s.sendMessage(data);
        });
      },
    )).listen((_) {}, onDone: () {
      print('Client disconnected: ${client.remoteAddress}:${client.remotePort}');
      sessions.remove(session);
      session.dispose();
    });
  });
}
