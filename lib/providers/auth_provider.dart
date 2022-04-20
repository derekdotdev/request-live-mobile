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

enum Role {
  guest,
  host,
}

class AuthProvider extends ChangeNotifier {
  // Firebase Auth object
  late FirebaseAuth _auth;
  late FirebaseFirestore _firebaseFirestore;
  late Future<bool> _checkIsEntertainer;
  late bool _isEntertainer;

  // Default status
  Status _status = Status.uninitialized;

  Status get status => _status;

  Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);

  AuthProvider() {
    //initialise object
    _auth = FirebaseAuth.instance;

    //listener for authentication changes such as user sign in and sign out
    _auth.authStateChanges().listen(onAuthStateChanged);
  }

  //Create user object based on the given User
  UserModel _userFromFirebase(User? user) {
    if (user == null) {
      return UserModel(displayName: 'Null', uid: 'null');
    }

    _checkIsEntertainer = checkUserIsEntertainer(user.uid);
    _isEntertainer = _checkIsEntertainer as bool;

    return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL,
        isEntertainer: _isEntertainer);
  }

  Future<bool> checkUserIsEntertainer(String uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((data) => {
              data.data()!['isEntertainer'],
            });

    if (snapshot.toString() == 'true') {
      return true;
    }
    return false;
  }

  Future<void> setUserAsEntertainer(String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'isEntertainer': 'true'});
  }

  //Method to detect live auth changes such as user sign in and sign out
  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _userFromFirebase(firebaseUser);
      _status = Status.authenticated;
    }
    notifyListeners();
  }

  //Method for new user registration using email and password
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password, bool isEntertainer) async {
    try {
      _status = Status.registering;
      notifyListeners();
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (isEntertainer) {
        await setUserAsEntertainer(result.user!.uid);
      }

      return _userFromFirebase(result.user);
    } catch (e) {
      print("Error on the new user registration = " + e.toString());
      _status = Status.unauthenticated;
      notifyListeners();
      return UserModel(displayName: 'Null', uid: 'null');
    }
  }

  //Method to handle user sign in using email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.authenticated;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return true;
    } catch (e) {
      print("Error on the sign in = " + e.toString());
      _status = Status.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //Method to handle user signing out
  Future signOut() async {
    _auth.signOut();
    _status = Status.unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
