import 'package:flutter/material.dart';
import 'package:new_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_app/page/home.dart';

class ModeratingPage extends StatefulWidget {
  final String sessionID;

  ModeratingPage({required this.sessionID, required String sessionId});

  @override
  _ModeratingPageState createState() => _ModeratingPageState();
}

// var sessions = snapshot.data?.docs ?? [];
class _ModeratingPageState extends State<ModeratingPage> {
  final SessionBloc sessionBloc = SessionBloc();

  void _endSession() async {
    await sessionBloc.removeSession(widget.sessionID);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sessionBloc.getSessions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var sessions = snapshot.data?.docs ?? [];
        var currentSession = sessions.where((s) => s.id == widget.sessionID);
        if (currentSession.isEmpty) {
          return Center(
            child: Text('Session not found'),
          );
        }

        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Text(currentSession.first['moderator']),
              ListView.builder(
                shrinkWrap: true,
                itemCount: currentSession.first['members'].length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    currentSession.first['members'][index],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _endSession,
                child: Text('End Session'),
              ),
            ],
          ),
        );
      },
    );
  }
}

//! buna bir bak ne oldugunu anlamadim 
// class _ModeratingPageState extends State<ModeratingPage> {
//   final SessionBloc sessionBloc = SessionBloc();

//   void _endSession() async {
//     await sessionBloc.removeSession(widget.sessionID);
//     Navigator.of(context).pop();
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
//         // var currentSession = currentSessionList[0];
//         var currentSessionList = sessions.where((s) => s.id == widget.sessionID).toList();
//         if (currentSessionList.isEmpty) {
//           return Center(
//             child: Text('Session not found'),
//           );
//         }

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

//!===== yenileme ekraninda takiliyor 
// class _ModeratingPageState extends State<ModeratingPage> {
//   final SessionBloc sessionBloc = SessionBloc();

//   void _endSession() async {
//     await sessionBloc.removeSession(widget.sessionID);
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: sessionBloc.getSessions(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data!.docs.isNotEmpty) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         var sessions = snapshot.data?.docs ?? [];
//         var currentSession = sessions.firstWhere((s) => s.id == widget.sessionID, orElse: () => null as QueryDocumentSnapshot<Object?>);
//         if (currentSession == null) {
//           return Center(
//             child: Text('Session not found'),
//           );
//         }

//         return Scaffold(
//           appBar: AppBar(),
//           body: Column(
//             children: [
//               Text(currentSession['moderator']),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: currentSession['members'].length,
//                 itemBuilder: (context, index) => ListTile(
//                   title: Text(
//                     currentSession['members'][index],
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
