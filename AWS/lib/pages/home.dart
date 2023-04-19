import 'dart:async';
// Amplify
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:new_app1/amplifyconfiguration.dart';

import 'package:new_app1/pages/member.dart';
import 'package:new_app1/pages/moderator.dart';
import '../models//ModelProvider.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {
  StreamSubscription<QuerySnapshot<Session>>? _stream;
  // Initialize a boolean indicating if the sync process has completed
  bool _isSynced = false;

  String? _currentUser;
  List<Session> _sessions = [];
  List<ParticipantSession> _participantSession = [];

  // Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUser();
    _getSessions();
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   _getSessions();
    // });
  }

  void dispose() {
    _stream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Current User: ${_currentUser}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    await Amplify.Auth.signOut();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Sign out'),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Icon(Icons.power_settings_new_outlined),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _getSessions();
                  },
                  child: Text('Get Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'Sessions:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(height: 10),
          //^ Session List
          Expanded(
            child: ListView.builder(
              itemCount: _sessions.length,
              itemBuilder: (BuildContext context, int index) {
                final session = _sessions[index];
                final isModerator = session.moderator == _currentUser;
                return ListTile(
                  title: Text('Session ${session.id}'),
                  subtitle: Text('Moderator: ${session.moderator}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isModerator)
                        ElevatedButton(
                          onPressed: () {
                            _joinSession(session.id);
                          },
                          child: Text('Join'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      if (isModerator)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ModeratingPage(sessionID: session.id),
                              ),
                            );
                          },
                          child: Text('Go Session'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      SizedBox(width: 8),
                      if (isModerator)
                        ElevatedButton(
                          onPressed: () {
                            _deleteSession(session);
                          },
                          child: Row(
                            children: [
                              Text('Delete'),
                              Icon(Icons.delete),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          //^ Bottom Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: _createSession,
                icon: Icon(Icons.add_circle),
                label: const Text(
                  'Create Session',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(double.infinity, 50), // butonun genişliğini ekrana tamamen yaymak için
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getCurrentUser() async {
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      print("User id: ${authUser.userId}, user name: ${authUser.username}");
      print("--------------");
      setState(() {
        _currentUser = authUser.username;
      });
    } on Exception catch (e) {
      print('Error getting current user: $e');
    }
  }

  void _getSessions() async {
    try {
      final response = await Amplify.DataStore.query(Session.classType as ModelType<Model>);
      List<Session> sessions = response.map((e) => Session.fromJson(e.toJson())).toList();
      setState(() {
        _sessions = sessions;
      });
      _stream = Amplify.DataStore.observeQuery(
        Session.classType,
      ).listen((QuerySnapshot<Session> snapshot) {
        setState(() {
          _sessions = snapshot.items;
          _isSynced = snapshot.isSynced;
        });
      });
    } on Exception catch (e) {
      print('Error getting sessions: $e');
    }
  }

  void _createSession() async {
    try {
      final sessionID = Random().nextInt(1000000).toString().padLeft(6, '0');
      final session = Session(id: sessionID, moderator: _currentUser!, participants: []);
      try {
        await Amplify.DataStore.save(session);
        await Amplify.DataStore.start();
        //! await Amplify.DataStore.save<Session>(session);
        // setState(() {
        //   _sessions.add(session);
        // });
      } on DataStoreException catch (e) {
        print('Error saving session to DataStore: ${e.message}');
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ModeratingPage(sessionID: sessionID),
        ),
      );
    } on Exception catch (e) {
      print('Error creating session: $e');
    }
  }

  void _deleteSession(Session session) async {
    try {
      final sessionID = session.id;
      // Delete all ParticipantSession objects with matching SessionID
      final participantSessions = await Amplify.DataStore.query(
        ParticipantSession.classType,
        where: ParticipantSession.SESSIONID.eq(int.parse(sessionID)),
      );
      for (final participantSession in participantSessions) {
        await Amplify.DataStore.delete(participantSession);
      }
      // Delete the Session object itself
      await Amplify.DataStore.delete(session);
      setState(() {
        _sessions.remove(session);
      });
    } on DataStoreException catch (e) {
      print('Error deleting session from DataStore: ${e.message}');
    }
  }

  void _joinSession(String sessionID) async {
    try {
      final session = _sessions.firstWhere((s) => s.id == sessionID);
      final isUserParticipant = session.participants.contains(_currentUser!);

      //! ParticipantSession
      final participantSession = ParticipantSession(SessionID: int.parse(session.id), moderator: session.moderator, participant: _currentUser!);
      final isParticipantSessionExists = await _isParticipantSessionExists(participantSession);

      if (isUserParticipant && isParticipantSessionExists) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ParticipatingPage(sessionID: sessionID),
          ),
        );
      } else {
        final participants = List<String>.from(session.participants);
        participants.add(_currentUser!);
        final updatedSession = session.copyWith(participants: participants);
        await Amplify.DataStore.save(updatedSession);

        if (!isParticipantSessionExists) {
          try {
            await Amplify.DataStore.save(participantSession);
            await Amplify.DataStore.start();
            setState(() {
              _participantSession.add(participantSession);
            });
          } on DataStoreException catch (e) {
            print('Error saving session to DataStore: ${e.message}');
          }
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ParticipatingPage(sessionID: sessionID),
          ),
        );
      }
    } on Exception catch (e) {
      print('Error joining session: $e');
    }
  }

  Future<bool> _isParticipantSessionExists(ParticipantSession participantSession) async {
    try {
      final result = await Amplify.DataStore.query(
        ParticipantSession.classType,
        where: ParticipantSession.SESSIONID.eq(participantSession.SessionID).and(ParticipantSession.PARTICIPANT.eq(participantSession.participant)),
      );
      return result.isNotEmpty;
    } on DataStoreException catch (e) {
      print('Error querying ParticipantSession from DataStore: ${e.message}');
      return false;
    }
  }

  
}
