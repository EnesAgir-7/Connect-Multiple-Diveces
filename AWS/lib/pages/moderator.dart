import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:new_app1/pages/home.dart';
import 'package:flutter/material.dart';

class ModeratingPage extends StatefulWidget {
  const ModeratingPage({super.key, required String sessionID});

  @override
  State<ModeratingPage> createState() => _ModeratingPageState();
}

class _ModeratingPageState extends State<ModeratingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moderator'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('This page Moderator Page'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Remove Session'),
            ),
          ],
        ),
      ),
    );
  }
}
