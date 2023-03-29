import 'package:flutter/material.dart';
import 'package:new_project/connection/modiator.dart';

class joinSession extends StatefulWidget {
  const joinSession({super.key});

  @override
  State<joinSession> createState() => _joinSessionState();
}

class _joinSessionState extends State<joinSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => JoinSessionPage(),
            child: Text("Join"),
          ),
        ],
      ),
    );
  }
}
