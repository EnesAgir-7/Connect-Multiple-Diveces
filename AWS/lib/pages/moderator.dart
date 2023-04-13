import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:new_app1/models/Session.dart';
import 'package:new_app1/pages/home.dart';
import 'package:flutter/material.dart';

class ModeratingPage extends StatefulWidget {
  const ModeratingPage({super.key, required String session});

  @override
  State<ModeratingPage> createState() => _ModeratingPageState();
}

class _ModeratingPageState extends State<ModeratingPage> {
  late Session _session;

  @override
  void initState() {
    super.initState();
    _getSession();
  }

  void _getSession() async {
    // try {
    //   final sessions = await Amplify.DataStore.query(
    //     Session.classType,
    //     where: Session.ID.eq(widget.sessionID),
    //   );
    //   if (sessions.isNotEmpty) {
    //     setState(() {
    //       _session = sessions.first;
    //     });
    //   }
    // } on DataStoreException catch (e) {
    //   print('Error getting session from DataStore: ${e.message}');
    // }
  }

  void _deleteSession(Session session) async {
    try {
      //await Amplify.DataStore.delete(session);
      setState(() {});
      Navigator.of(context).pop();
      print("go back");
    } on DataStoreException catch (e) {
      print('Error deleting session from DataStore: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moderator'),
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
            ElevatedButton(
              onPressed: () {
                _deleteSession(_session);
              },
              child: const Text('delete Session'),
            ),
            const SizedBox(height: 20),
            // Text(
            //   'Participants (${_session.participants.length}):',
            //   style: TextStyle(fontSize: 20),
            // ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: _session.participants.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       return ListTile(
            //         title: Text('Participant ${index + 1}'),
            //         subtitle: Text(_session.participants[index]),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
