import 'package:flutter/material.dart';
import 'package:new_app/main.dart';
import 'package:new_app/page/moderating.dart';

class CreateSessionPage extends StatefulWidget {
  final SessionBloc sessionBloc;

  CreateSessionPage({required this.sessionBloc});

  @override
  _CreateSessionPageState createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  TextEditingController moderatorIDController = TextEditingController();
  TextEditingController sessionIDController = TextEditingController();

  void _createSession(BuildContext context) async {
    await widget.sessionBloc.addSession(moderatorIDController.text, sessionIDController.text);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModeratingPage(sessionID: sessionIDController.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        TextField(controller: moderatorIDController, decoration: InputDecoration(hintText: 'Enter moderator ID')),
        TextField(controller: sessionIDController, decoration: InputDecoration(hintText: 'Enter session ID')),
        ElevatedButton(onPressed: () => _createSession(context), child: Text('Create Session'))
      ],
    ));
  }
}
