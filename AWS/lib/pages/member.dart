import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:new_app1/models/Session.dart';
import 'package:new_app1/pages/home.dart';

class ParticipatingPage extends StatefulWidget {
  final String sessionID;
  const ParticipatingPage({super.key, required this.sessionID});

  @override
  State<ParticipatingPage> createState() => _ParticipatingPageState();
}

class _ParticipatingPageState extends State<ParticipatingPage> {
  StreamSubscription<QuerySnapshot<Session>>? _stream;
  bool _isSynced = false;
  List<Session> _sessions = [];

  // String? _currentUser;
  late Session _session;

  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSession();
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   _getSession();
    // });
  }

  void _getSession() async {
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      _stream = Amplify.DataStore.observeQuery(
        Session.classType,
        where: Session.ID.eq(widget.sessionID),
      ).listen((event) {
        final updatedSessions = event.items;
        if (updatedSessions.isEmpty) {
          Navigator.of(context).pop();
        } else {
          final updatedSession = updatedSessions.first;
          setState(() {
            _session = updatedSession;
          });
          if (!_session.participants.contains(authUser.username)) {
            Navigator.of(context).pop();
          }
        }
      });
      final sessions = await Amplify.DataStore.query(
        Session.classType,
        where: Session.ID.eq(widget.sessionID),
      );
      if (sessions.isEmpty) {
        Navigator.of(context).pop();
      } else {
        setState(() {
          _session = sessions.first;
        });
        if (!_session.participants.contains(authUser.username)) {
          Navigator.of(context).pop();
        }
      }
    } on DataStoreException catch (e) {
      print('Error getting session from DataStore: ${e.message}');
    }
  }


  void _exitFromSession() async {
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      final updatedSession = _session.copyWith(
        participants: List<String>.from(_session.participants)..remove(currentUser.username),
      );
      // final participants = List<String>.from(_session.participants);
      // participants.remove(currentUser.username);
      // final updatedSession = _session.copyWith(participants: participants);
      await Amplify.DataStore.save(updatedSession);
      //! I don't understand, why did not work
      // Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
      );
    } on DataStoreException catch (e) {
      print('Error exiting from session: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Member page"),
      ),
      body: Column(
        children: [
          Text(
            'Moderator: ${_session.moderator}',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(child: Container()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  _exitFromSession();
                },
                icon: Icon(Icons.arrow_back_ios),
                label: const Text('Leave Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
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
}
