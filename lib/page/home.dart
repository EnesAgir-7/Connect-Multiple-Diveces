import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_app/auth.dart';
import 'package:new_app/page/create_session.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text("Connect Devices");
  }

  Widget _userUid() {
    return Text(user?.email ?? 'user email');
  }

  Widget _singOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: Text("Sign Out"),
    );
  }

  // Widget _createSession(BuildContext context) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => CreateSessionPage()),
  //       );
  //     },
  //     child: const Text("Create Session"),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _singOutButton(),
            // _createSession(),
          ],
        ),
      ),
    );
  }
}
