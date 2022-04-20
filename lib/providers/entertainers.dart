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

  Future<void> fetchEntertainers() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (querySnapshot) => {
            for (var doc in querySnapshot.docs)
              {
                if (doc.data()['isDj'] == true)
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
