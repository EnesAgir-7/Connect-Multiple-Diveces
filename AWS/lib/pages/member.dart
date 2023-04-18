import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:new_app1/models/ModelProvider.dart';
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
  List<ParticipantSession> _participantSession = [];

  // String? _currentUser;
  late Session _session;

  Timer? _timer;

  bool sessionInitialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSession());
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   _getSession();
    // });
  }

  void _initSession() async {
    await _getSession();
    setState(() {
      sessionInitialized = true;
    });
  }

  Future<void> _getSession() async {
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      _stream = Amplify.DataStore.observeQuery(
        Session.classType,
        where: Session.ID.eq(widget.sessionID),
      ).listen((event) {
        final updatedSessions = event.items;
        if (updatedSessions.isEmpty) {
          _handleSessionNotFound();
        } else {
          final updatedSession = updatedSessions.first;
          _updateSession(updatedSession, authUser.username);
        }
      });
      final sessions = await Amplify.DataStore.query(
        Session.classType,
        where: Session.ID.eq(widget.sessionID),
      );
      if (sessions.isNotEmpty) {
        final session = sessions.first;
        _updateSession(session, authUser.username);
      } else {
        _handleSessionNotFound();
      }
    } on DataStoreException catch (e) {
      print('Error getting session from DataStore: ${e.message}');
    }
  }

  void _handleSessionNotFound() {
    Navigator.of(context).pop();
  }

  void _updateSession(Session session, String username) {
    setState(() {
      _session = session;
    });
    if (!_session.participants.contains(username)) {
      Navigator.of(context).pop();
    }
  }

  void _exitFromSession() async {
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      final updatedSession = _session.copyWith(
        participants: List<String>.from(_session.participants)..remove(currentUser.username),
      );
      // final updatedParticipantSession = _participantSession.copyWith()
      await Amplify.DataStore.save(updatedSession);
      Navigator.of(context).pop();
    } on DataStoreException catch (e) {
      print('Error exiting from session: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sessionInitialized) {
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
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
