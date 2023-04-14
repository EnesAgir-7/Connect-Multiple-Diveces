import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:new_app1/models/Session.dart';
import 'package:new_app1/pages/home.dart';
import 'package:flutter/material.dart';

class ModeratingPage extends StatefulWidget {
  final String sessionID;

  const ModeratingPage({super.key, required this.sessionID});

  @override
  State<ModeratingPage> createState() => _ModeratingPageState();
}

class _ModeratingPageState extends State<ModeratingPage> {
  StreamSubscription<QuerySnapshot<Session>>? _stream;
  List<Session> _sessions = [];
  bool _isSynced = false;
  late Session _session;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getSession();
    _refreshSession();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getSession() async {
    try {
      final sessions = await Amplify.DataStore.query(
        Session.classType,
        where: Session.ID.eq(widget.sessionID),
      );
      if (sessions.isNotEmpty) {
        setState(() {
          _session = sessions.first;
        });
      }
    } on DataStoreException catch (e) {
      print('Error getting session from DataStore: ${e.message}');
    }
  }

  void _deleteSession(Session session) async {
    try {
      await Amplify.DataStore.delete(session);
      Navigator.of(context).pop();
      print("go back");
    } on DataStoreException catch (e) {
      print('Error deleting session from DataStore: ${e.message}');
    }
  }

  void _refreshSession() async {
    try {
      final sessions = await Amplify.DataStore.query(
        Session.classType,
        where: Session.ID.eq(widget.sessionID),
      );
      if (sessions.isNotEmpty) {
        final session = sessions.first;
        _stream?.cancel(); // cancel any existing subscription
        _stream = Amplify.DataStore.observeQuery(
          Session.classType,
          where: Session.ID.eq(widget.sessionID),
        ).listen((QuerySnapshot<Session> snapshot) {
        setState(() {
            _session = snapshot.items.first;
          });
        });
      }
    } on DataStoreException catch (e) {
      print('Error getting session from DataStore: ${e.message}');
    }
  }

  void _removeParticipant(int index) async {
    try {
      // Convert fixed-length list to mutable list
      List<String> mutableParticipants = List<String>.from(_session.participants);
      mutableParticipants.removeAt(index);
      // Update the session with the new participants list
      final updatedSession = _session.copyWith(participants: mutableParticipants);
      await Amplify.DataStore.save(updatedSession);
      _refreshSession();
    } on DataStoreException catch (e) {
      print('Error removing participant from session: ${e.message}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Moderator: ${_session.moderator}',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _deleteSession(_session);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('This page Moderator Page'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _deleteSession(_session);
                    },
                    child: const Text('delete Session'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: _refreshSession,
                    child: const Text('Refresh Participants'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Participants (${_session.participants.length}):',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _session.participants.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    // title: Text('Participant ${index + 1}'),
                    subtitle: Text(
                      _session.participants[index],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _removeParticipant(index);
                          },
                          child: Icon(Icons.close),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700], // Set the button color to red
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
