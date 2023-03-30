import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:new_app/widget_tree.dart';
import 'firebase_options.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetTree(),
    );
  }
}


class SessionBloc {
  final CollectionReference sessionCollection = FirebaseFirestore.instance.collection('sessions');

  Future<void> addSession(String moderatorID, String sessionID) async {
    return sessionCollection.doc(sessionID).set({
      'moderator': moderatorID,
      'members': [],
    });
  }

  Future<void> removeSession(String sessionID) async {
    return sessionCollection.doc(sessionID).delete();
  }

  Stream<QuerySnapshot> getSessions() {
    return sessionCollection.snapshots();
  }
}
