import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:new_app1/amplifyconfiguration.dart';
import 'package:new_app1/pages/member.dart';
import 'package:new_app1/pages/moderator.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import '../models//ModelProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {
  String? _currentUser;
  List<Session> _sessions = [];
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUser();
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
    } on Exception catch (e) {
      print('Error getting sessions: $e');
    }
  }

  void _createSession() async {
    try {
      print("--------------");
      final sessionID = Random().nextInt(1000000).toString().padLeft(6, '0');
      print(sessionID);
      final session = Session(id: sessionID, moderator: _currentUser!, participants: []);
      try {
        await Amplify.DataStore.start();
        await Amplify.DataStore.save(session);
        //! await Amplify.DataStore.save<Session>(session);
        setState(() {
          _sessions.add(session);
        });
      } on DataStoreException catch (e) {
        print('Error saving session to DataStore: ${e.message}');
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ModeratingPage(
            sessionID: sessionID,
          ),
        ),
      );
    } on Exception catch (e) {
      print('Error creating session: $e');
    }
  }


  void _joinSession(String sessionID) async {
    try {
      final session = _sessions.firstWhere((s) => s.id == sessionID);
      final participants = List<String>.from(session.participants);
      participants.add(_currentUser!);
      final updatedSession = session.copyWith(participants: participants);
      await Amplify.DataStore.save(updatedSession);
      setState(() {
        _sessions[_sessions.indexOf(session)] = updatedSession;
      });
    } on Exception catch (e) {
      print('Error joining session: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connect Devices')),
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
            ),
            Text('Sessions:'),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _sessions.length,
                itemBuilder: (BuildContext context, int index) {
                  final session = _sessions[index];
                  return ListTile(
                    title: Text('Session ${session.id}'),
                    subtitle: Text('Moderator: ${session.moderator}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _joinSession(session.id);
                      },
                      child: Text('Join'),
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

// class Session extends Model {
//   final String id;
//   final String moderator;
//   final List<String> participants;

//   Session({required this.id, required this.moderator, required this.participants});

//   static const classType = 'session';

//   @override
//   String getId() {
//     return id;
//   }

//   factory Session.fromJson(Map<String, dynamic> json) {
//     return Session(
//       id: json['id'],
//       moderator: json['moderator'],
//       participants: List<String>.from(json['participants']),
//     );
//   }

//   Session copyWith({
//     String? id,
//     String? moderator,
//     List<String>? participants,
//   }) {
//     return Session(
//       id: id ?? this.id,
//       moderator: moderator ?? this.moderator,
//       participants: participants ?? this.participants,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'moderator': moderator,
//       'participants': participants,
//     };
//   }
// }
