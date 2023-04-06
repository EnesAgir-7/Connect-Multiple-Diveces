import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:new_app1/pages/home.dart';

class ModeratingPage extends StatefulWidget {
  const ModeratingPage({super.key});

  @override
  State<ModeratingPage> createState() => _ModeratingPageState();
}

class _ModeratingPageState extends State<ModeratingPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class ModeratingPage extends StatefulWidget {
//   final Session session;

//   ModeratingPage({required this.session});

//   @override
//   _ModeratingPageState createState() => _ModeratingPageState();
// }

// class _ModeratingPageState extends State<ModeratingPage> {
//   final SessionBloc sessionBloc = SessionBloc();

//   void _endSession() async {
//     // await sessionBloc.removeSession(widget.sessionID);
//     // Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: sessionBloc.getSessions(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         var sessions = snapshot.data?.docs ?? [];
//         var currentSession = sessions.where((s) => s.id == widget.sessionID);
//         // var currentSession = sessions.firstWhere((s) => s.id == widget.sessionID);

//         if (currentSession.isEmpty) {
//           return Center(
//             child: Text('Session not found'),
//           );
//         }

//         return Scaffold(
//           appBar: AppBar(),
//           body: Column(
//             children: [
//               Text(currentSession.first['moderator']),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: currentSession.first['members'].length,
//                 itemBuilder: (context, index) => ListTile(
//                   title: Text(
//                     currentSession.first['members'][index],
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: _endSession,
//                 child: Text('End Session'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
