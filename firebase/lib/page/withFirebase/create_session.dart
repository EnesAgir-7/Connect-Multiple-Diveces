import 'package:flutter/material.dart';
import 'package:new_app/page/home.dart';
import 'package:new_app/page/withFirebase/moderating.dart';

// class CreateSessionPage extends StatefulWidget {
//   final SessionBloc sessionBloc;
//   final String sessionID;


//   CreateSessionPage({required this.sessionBloc, required this.sessionID});

//   @override
//   _CreateSessionPageState createState() => _CreateSessionPageState();
// }

// class _CreateSessionPageState extends State<CreateSessionPage> {
//   TextEditingController moderatorIDController = TextEditingController();
//   TextEditingController sessionIDController = TextEditingController();

//   void _createSession(BuildContext context) async {
//     await widget.sessionBloc.addSession(moderatorIDController.text, sessionIDController.text);
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ModeratingPage(
//           sessionID: sessionIDController.text,
//           // sessionID: widget.sessionID,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Create Session"),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(controller: moderatorIDController, decoration: InputDecoration(hintText: 'Enter moderator ID')),
//             TextField(controller: sessionIDController, decoration: InputDecoration(hintText: 'Enter session ID')),
//             ElevatedButton(onPressed: () => _createSession(context), child: Text('Create Session'))
//           ],
//         ),
//       ),
//     );
//   }
// }

class Session {
  String sessionID;
  String moderatorID;
  List participantEmails;

  Session({required this.sessionID, required this.moderatorID, required this.participantEmails});

  Map<String, dynamic> toJson() => {
        'sessionID': sessionID,
        'moderatorID': moderatorID,
        'participantEmails': participantEmails,
      };

  Session.fromJson(Map<String, dynamic> json)
      : sessionID = json['sessionID'],
        moderatorID = json['moderatorID'],
        participantEmails = List.from(
          json['participantEmails'],
        );
}
