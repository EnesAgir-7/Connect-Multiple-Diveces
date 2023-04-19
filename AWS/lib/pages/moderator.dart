import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:new_app1/models/ParticipantSession.dart';
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
  bool _isSynced = false;
  late Session _session;

  bool sessionInitialized = false;
  List<ParticipantSession> _participantSession = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSession());
  }

  void _initSession() async {
    await _getSession();
    _refreshSession();
    setState(() {
      sessionInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (sessionInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Moderator: ${_session.moderator}',
            style: TextStyle(fontSize: 20),
          ),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () {
          //     _deleteSession(_session);
          //   },
          // ),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  'This page Moderator Page',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
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
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String set = '';
                                      return AlertDialog(
                                        title: Text('Send a Sets'),
                                        content: TextField(
                                          onChanged: (value) {
                                            set = value;
                                          },
                                          decoration: InputDecoration(hintText: 'Type your assignments set'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Do something with the sets
                                              _sendSets(set, _session.participants[index]);
                                              print(set);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Send'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(Icons.message),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: CircleBorder(),
                                ),
                              ),
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
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              //^ bottom button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _deleteSession(_session);
                    },
                    icon: Icon(Icons.delete),
                    label: const Text('Delete Session'),
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
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Future<void> _getSession() async {
    try {
      final response = await Amplify.DataStore.query(ParticipantSession.classType as ModelType<Model>);
      List<ParticipantSession> participantSession = response.map((e) => ParticipantSession.fromJson(e.toJson())).toList();
      final sessions = await Amplify.DataStore.query(
        Session.classType,
        where: Session.ID.eq(widget.sessionID),
      );
      if (sessions.isNotEmpty) {
        setState(() {
          _session = sessions.first;
          _participantSession = participantSession;
        });
      }
    } on DataStoreException catch (e) {
      print('Error getting session from DataStore: ${e.message}');
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
        // _stream?.cancel(); // cancel any existing subscription
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

  Future<void> _sendSets(String Participant, String set) async {
    final participant = await Amplify.DataStore.query(
      ParticipantSession.classType,
      where: ParticipantSession.PARTICIPANT.eq(Participant),
    );

    final participantSession = await Amplify.DataStore.query(
      ParticipantSession.classType,
      where: ParticipantSession.SESSIONID.eq(_session.id),
    );

    final sets = List<String>.from(participantSession[0].sets as Iterable);
    sets.add(set);

    final updatedParticipantSession = participantSession[0].copyWith(sets: sets);

    await Amplify.DataStore.save(updatedParticipantSession);
  }


  
}
