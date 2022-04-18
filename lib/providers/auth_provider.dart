import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  registering
}

class AuthProvider extends ChangeNotifier {
  // Firebase Auth object
  late FirebaseAuth _auth;
  late FirebaseFirestore _firebaseFirestore;

  // Default status
  Status _status = Status.uninitialized;

  Status get status => _status;

  Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);

  AuthProvider() {
    // Initialize object
    _auth = FirebaseAuth.instance;
    // Listener for auth changes (sign in/out)
    // _auth.authStateChanges().listen((event) {
    //   event = _auth.onAuthStateChanged
    // });
  }

  // Create user object based on the given user
  UserModel _userFromFirebase(User? user) {
    if (user == null) {
      return UserModel(displayName: 'Null', uid: 'null', isEntertainer: false);
    }

    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      isEntertainer: false,
      // isEntertainer: user.is
    );
  }
}
