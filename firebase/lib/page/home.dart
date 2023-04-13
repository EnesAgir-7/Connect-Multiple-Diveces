import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_app/auth.dart';
import 'package:new_app/page/withFirebase/moderating.dart';
import 'package:new_app/page/withFirebase/participaring.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final User _currentUser;
  final TextEditingController _sessionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
  }

  Future<void> _createSession() async {
    // Uniq ID for the session
    final String sessionID = _db.collection('sessions').doc().id;
    print("--------------------");
    print(sessionID);
    await _db.collection('sessions').doc(sessionID).set({
      'moderator': _currentUser.email,
      'members': [_currentUser.email],
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ModeratingPage(
          sessionID: sessionID,
        ),
      ),
    );
  }

  Future<void> _joinSession(String sessionID) async {
    final DocumentSnapshot<Map<String, dynamic>> session = await _db.collection('sessions').doc(sessionID).get();

    // Check if session exists
    if (!session.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session not found')),
      );
      return;
    }

    final List<dynamic>? members = session.data()?['members'] as List<dynamic>?;
    final String? moderator = session.data()?['moderator'] as String?;

    // Check if user has already joined
    if (members != null && members.contains(_currentUser.email)) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ParticipatingPage(sessionID: sessionID),
      ));
      return;
    }

    // Update members and send to the session
    final Map<String, dynamic> updatedSession = {'members': members ?? [], 'moderator': moderator};
    (updatedSession['members'] as List<dynamic>).add(_currentUser.email);

    await _db.collection('sessions').doc(sessionID).update(updatedSession);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ParticipatingPage(sessionID: sessionID),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Devices'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_currentUser.email ?? 'No user email'),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text('Sign Out'),
            ),
            ElevatedButton(
              onPressed: _createSession,
              child: Text('Create Session'),
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Join Session'),
                  content: TextField(
                    controller: _sessionController,
                    decoration: InputDecoration(hintText: 'Session ID'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final String sessionID = _sessionController.text.trim();
                        Navigator.of(context).pop();
                        await _joinSession(sessionID);
                      },
                      child: Text('Join'),
                    ),
                  ],
                ),
              ),
              child: Text('Join Session'),
            ),
          ],
        ),
      ),
    );
  }
}

class Session {
  final String sessionID;
  final String moderator;
  final List<String> members;

  Session({
    required this.sessionID,
    required this.moderator,
    required this.members,
  });

  factory Session.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Session(
      sessionID: snapshot.id,
      moderator: data['moderator'],
      members: List<String>.from(data['members']),
    );
  }
}

class SessionBloc {
  final CollectionReference sessionCollection = FirebaseFirestore.instance.collection('sessions');

  Future<String> addSession(String moderatorID, String text) async {
    var sessionID = FirebaseFirestore.instance.collection('sessions').doc().id;

    await sessionCollection.doc(sessionID).set({
      'moderator': moderatorID,
      'members': [],
    });

    return sessionID;
  }

  Future<void> removeSession(String sessionID) async {
    return sessionCollection.doc(sessionID).delete();
  }

  Stream<QuerySnapshot> getSessions() {
    return sessionCollection.snapshots();
  }
}
