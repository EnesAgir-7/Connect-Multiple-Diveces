import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:new_app1/pages/member.dart';
import 'package:new_app1/pages/moderator.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {
  final TextEditingController _sessionController = TextEditingController();
  // late final AmplifyAuthCognito _auth;
  // late final AmplifyDataStore _dataStore;
  // // late final User _currentUser;

  // @override
  // void initState() {
  //   super.initState();
  //   _configureAmplify();
  //   _getCurrentUser();
  // }

  // Future<void> _configureAmplify() async {
  //   await Amplify.addPlugin(AmplifyAuthCognito());
  //   // await Amplify.addPlugin(AmplifyDataStore(modelProvider: ModelProvider.instance));
  //   // await Amplify.configure();
  //   _auth = Amplify.Auth as AmplifyAuthCognito;
  //   _dataStore = Amplify.DataStore as AmplifyDataStore;
  // }

  // Future<void> _getCurrentUser() async {
  //   // try {
  //   //   final authUser = await _auth.getCurrentUser();
  //   //   setState(() {
  //   //     _currentUser = authUser;
  //   //   });
  //   // } on AuthException catch (e) {
  //   //   print(e.message);
  //   // }
  // }

  // Future<void> _createSession() async {
  //   // Unique ID for the session
  //   final sessionID = Uuid().v4();
  //   print("--------------------");
  //   print(sessionID);
  //   // await _dataStore.save(Session(
  //   //   sessionID: sessionID,
  //   //   moderator: _currentUser.username,
  //   //   members: [_currentUser.username],
  //   // ));
  //   // Navigator.of(context).push(MaterialPageRoute(
  //   //   builder: (_) => ModeratingPage(sessionID: sessionID),
  //   // ));
  // }

  // Future<void> _joinSession(String sessionID) async {
  //   // final DocumentSnapshot<Map<String, dynamic>> session = await _db.collection('sessions').doc(sessionID).get();
  //   // try {
  //   //   final session = await _dataStore.query(Session.classType, where: Session.SESSION_ID.eq(sessionID));
  //   //   if (session.isEmpty) {
  //   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Session not found')));
  //   //     return;
  //   //   }
  //   //   final updatedSession = session.first.copyWith(members: [...session.first.members, _currentUser.username]);
  //   //   await _dataStore.save(updatedSession);
  //   //   Navigator.of(context).push(MaterialPageRoute(
  //   //     builder: (_) => ParticipatingPage(sessionID: updatedSession.sessionID),
  //   //   ));
  //   // } on DataStoreException catch (e) {
  //   //   print(e.message);
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connect Devices')),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(_currentUser.username ?? 'No user email'),
            ElevatedButton(
              onPressed: () async {
                // await _auth.signOut();
              },
              child: Text('Sign out'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // await _createSession();
              },
              child: Text('Create a session'),
            ),
          ],
        ),
      ),
    );
  }
}

// class Session {
//   final String sessionID;
//   final String moderator;
//   final List<String> members;

//   Session({
//     required this.sessionID,
//     required this.moderator,
//     required this.members,
//   });

//   factory Session.fromSnapshot(DocumentSnapshot snapshot) {
//     final data = snapshot.data() as Map<String, dynamic>;
//     return Session(
//       sessionID: snapshot.id,
//       moderator: data['moderator'],
//       members: List<String>.from(data['members']),
//     );
//   }
// }

class SessionBloc {
  final DataStoreCategory _dataStore = Amplify.DataStore;
  // final DataStoreCategory sessionCollection = AmplifyAuthCognito.
  // final sessionID = Uuid().v4();

  // Future<String> addSession(String moderatorID, String text) async {
  //   // var sessionID = FirebaseFirestore.instance.collection('sessions').doc().id;
  //   var sessionID = AmplifyAlreadyConfiguredException;

  //   await sessionCollection.doc(sessionID).set({
  //     'moderator': moderatorID,
  //     'members': [],
  //   });

  //   return sessionID;
  // };

  // Future<void> removeSession(String sessionID) async {
  //   return sessionCollection.doc(sessionID).delete();
  // }

  // Stream<List<Session>> getSessions() {
  //   return Amplify.DataStore.query(Session.classType).asStream().map((event) => event.map((e) => e.item).toList());
  // }

}
