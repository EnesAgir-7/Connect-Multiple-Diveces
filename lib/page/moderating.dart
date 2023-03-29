import 'package:flutter/material.dart';
import 'package:new_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModeratingPage extends StatefulWidget {
  final String sessionID;

  ModeratingPage({required this.sessionID});

  @override
  _ModeratingPageState createState() => _ModeratingPageState();
}

class _ModeratingPageState extends State<ModeratingPage> {
  final SessionBloc sessionBloc = SessionBloc();

  void _endSession() async {
    await sessionBloc.removeSession(widget.sessionID);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sessionBloc.getSessions(),
      builder: (context, snapshot) {
        var sessions = snapshot.data!.docs;
        var currentSession = sessions.where((s) => s.id == widget.sessionID).first;

        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Text(currentSession['moderator']),
              ListView.builder(
                shrinkWrap: true,
                itemCount: currentSession['members'].length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    currentSession['members'][index],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _endSession,
                child: Text('End Session'),
              ),
            ],
          ),
        );
      },
    );
  }
}
