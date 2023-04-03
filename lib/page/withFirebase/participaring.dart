import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_app/page/home.dart';

class ParticipatingPage extends StatelessWidget {
  final String sessionId;

  const ParticipatingPage({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participating Page'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('sessions').doc(sessionId).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final Session session = Session.fromSnapshot(snapshot.data!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Session ID: ${session.sessionId}'),
              Text('Moderator: ${session.moderator}'),
              Text('Members: ${session.members.join(', ')}'),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Leave Session'),
              ),
            ],
          );
        },
      ),
    );
  }
}
