import 'package:flutter/material.dart';
import 'package:new_project/connection/modiator.dart';

class startSession extends StatefulWidget {
  const startSession({super.key});

  @override
  State<startSession> createState() => _startSessionState();
}

class _startSessionState extends State<startSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => CreateSessionPage,
            child: Text("Start"),
          ),
        ],
      ),
    );
  }
}
