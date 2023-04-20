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
  StreamSubscription<QuerySnapshot<ParticipantSession>>? _stream2;
  bool _isSynced = false;
  List<Session> _sessions = [];
  List<ParticipantSession> _participantSession = [];
  String? _currentUser;
  List<String> _participantSets = [];

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
    // });
  }

  @override
  void dispose() {
    _stream?.cancel();
    _stream2?.cancel();
    super.dispose();
  }

  void _initSession() async {
    await _getSession();
    _getCurrentUser();
    _getParticipantSets();
    setState(() {
      sessionInitialized = true;
    });
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
            ElevatedButton(
              onPressed: () => _getParticipantSets(),
              child: Text('Get Sets'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _participantSets.length,
                itemBuilder: (BuildContext context, int index) {
                  final _participantSetsList = _participantSets[index];
                  return ListTile(
                    title: Text(_participantSetsList),
                  );
                },
              ),
            ),
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
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void _getParticipantSets() async {
    try {
      final participantSessions = await Amplify.DataStore.query(
        ParticipantSession.classType,
        where: ParticipantSession.PARTICIPANT.eq(_currentUser).and(ParticipantSession.SESSIONID.eq(widget.sessionID)),
      );
      _stream2 = Amplify.DataStore.observeQuery(ParticipantSession.classType,
              where: ParticipantSession.SESSIONID.eq(widget.sessionID).and(ParticipantSession.PARTICIPANT.eq(_currentUser)))
          .listen((QuerySnapshot<ParticipantSession> snapshot) {
        setState(() {
          _participantSession = snapshot.items;
          _isSynced = snapshot.isSynced;
        });
      });
      if (participantSessions.isNotEmpty) {
        final participantSession = participantSessions.first;
        setState(() {
          _participantSets = List<String>.from(participantSession.sets ?? []);
        });
      }
    } on DataStoreException catch (e) {
      print('Error getting sets for participant session: ${e.message}');
    }
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
      //! pop up is not working all time
      // Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } on DataStoreException catch (e) {
      print('Error exiting from session: ${e.message}');
    }
  }
}
