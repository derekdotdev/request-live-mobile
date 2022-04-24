// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:flutter/material.dart';
//
// class Entertainer {
//   final String uid;
//   final String userName;
//
//   Entertainer(this.uid, this.userName);
// }
//
// // Use this class to determine if username is taken
// // via a table which can be accessed if !auth
//
// // Use the uid to fetch other user
// class Entertainers with ChangeNotifier {
//   late List<Entertainer> _entertainersList;
//
//   List<Entertainer> get getEntertainers => _entertainersList;
//
//
//   Future<List<Entertainer>> fetchEntertainers() async {
//     List<Entertainer> entertainers = [];
//     await FirebaseFirestore.instance.collection('usernames').get().then(
//           (querySnapshot) => {
//             for (var doc in querySnapshot.docs)
//               {
//                 if (doc.data()['isDj'] == true)
//                   {
//                     entertainers.add(
//                       Entertainer(
//                         doc.data()['uid'],
//                         doc.data()['username'],
//                       ),
//                     ),
//                   },
//               },
//           },
//         );
//     return entertainers;
//   }
// }
