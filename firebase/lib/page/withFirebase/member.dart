// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:new_app/page/home.dart';

// class MemberPage extends StatefulWidget {
//   final SessionBloc sessionBloc;

//   MemberPage({required this.sessionBloc});

//   @override
//   _MemberPageState createState() => _MemberPageState();
// }

// class _MemberPageState extends State<MemberPage> {
//   TextEditingController memberIDController = TextEditingController();
//   TextEditingController sessionIDController = TextEditingController();

//   void _joinSession(BuildContext context) async {
//     var sessionID = sessionIDController.text;

//     var snapshot = await FirebaseFirestore.instance.collection('sessions').doc(sessionID).get();
//     if (!snapshot.exists) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Session does not exist.')));
//       return;
//     }

//     await FirebaseFirestore.instance.collection('sessions').doc(sessionID).update({
//       'members': FieldValue.arrayUnion([memberIDController.text])
//     });

//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemberPage(sessionBloc: widget.sessionBloc)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Column(
//       children: [
//         TextField(controller: memberIDController, decoration: InputDecoration(hintText: 'Enter your ID')),
//         TextField(controller: sessionIDController, decoration: InputDecoration(hintText: 'Enter session ID')),
//         ElevatedButton(onPressed: () => _joinSession(context), child: Text('Join Session'))
//       ],
//     ));
//   }
// }
