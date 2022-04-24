import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class Entertainer {
  final String uid;
  final String userName;
  final String email;

  Entertainer(this.uid, this.userName, this.email);
}

class Entertainers with ChangeNotifier {
  final List<Entertainer> _entertainersList = [];

  Future<List<String>> _fetchUserNamesInUse() async {
    print('_fetchUserNamesInUse() called!');
    List<String> usernames = [];
    var currentUsername = '';
    await FirebaseFirestore.instance
        .collection('usernames')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        currentUsername = element['username'].toString();
        print(currentUsername);
        usernames.add(currentUsername);
      });
    });

    print('Fetched Usernames: ');
    for (String s in usernames) {
      print(s);
    }
    return usernames;
  }

  Future<void> fetchEntertainers() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (querySnapshot) => {
            for (var doc in querySnapshot.docs)
              {
                if (doc.data()['is_entertainer'] == true)
                  {
                    _entertainersList.add(
                      Entertainer(
                        doc.data()['uid'],
                        doc.data()['username'],
                        doc.data()['email'],
                      ),
                    ),
                  },
              },
          },
        );
  }

  List<Entertainer> get entertainersList {
    return _entertainersList;
  }
}
