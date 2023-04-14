// For timer
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
  final TextEditingController _nameController = TextEditingController();
  Timer? _timer;

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
    // super.dispose();
    _timer?.cancel;
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
      //! did not work
      // _stream = Amplify.DataStore.observe(Session.classType).listen(
      //   (event) {
      //     print('Received event of type ' + event.eventType.toString());
      //     print('Received post ' + event.item.toString());
      //   },
      // ) as StreamSubscription<QuerySnapshot<Session>>?;
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

  List<String> getParticipants(Session session) {
    return List<String>.from(session.participants);
  }

  void _createSession() async {
    try {
      print("--------------");
      final sessionID = Random().nextInt(1000000).toString().padLeft(6, '0');
      print(sessionID);
      final session = Session(id: sessionID, moderator: _currentUser!, participants: []);
      try {
        await Amplify.DataStore.save(session);
        await Amplify.DataStore.start();
        //! await Amplify.DataStore.save<Session>(session);
        setState(() {
          _sessions.add(session);
        });
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
      final participants = List<String>.from(session.participants);
      participants.add(_currentUser!);
      final updatedSession = session.copyWith(participants: participants);
      await Amplify.DataStore.save(updatedSession);
      // setState(() {
      //   _sessions[_sessions.indexOf(session)] = updatedSession;
      // });
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ParticipatingPage(sessionID: sessionID),
        ),
      );
    } on Exception catch (e) {
      print('Error joining session: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current User: ${_currentUser}'),
            ElevatedButton(
              onPressed: () async {
                await Amplify.Auth.signOut();
              },
              child: Text('Sign out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _createSession();
              },
              child: Text('Create Session'),
            ),
            ElevatedButton(
              onPressed: () {
                _getSessions();
              },
              child: Text('Get Session'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text(
              'Sessions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
                          child: Text('Manager Page'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                        ),
                      SizedBox(width: 8),
                      if (isModerator)
                        ElevatedButton(
                          onPressed: () {
                            _deleteSession(session);
                          },
                          child: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                    ],
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
