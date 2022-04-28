import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../models/username_model.dart';
import '../models/request.dart';
import '../resources/firestore_database.dart';
import '../resources/storage_methods.dart';

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
  late FirebaseAuth _auth;
  late FirestoreDatabase _firestoreDatabase;
  late String _username = '';
  late bool _isEntertainer = false;
  late bool _isLive = false;

  AuthProvider() {
    //initialise object
    _auth = FirebaseAuth.instance;

    //listener for authentication changes such as user sign in and sign out
    _auth.authStateChanges().listen(onAuthStateChanged);
  }

  //Method to detect live auth changes such as user sign in and sign out
  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _userFromFirebaseWithFirestoreDetails(firebaseUser);
      _status = Status.authenticated;
    }
    notifyListeners();
  }

  Status _status = Status.uninitialized;
  Status get status => _status;

  Stream<UserModel> get user => _auth
      .authStateChanges()
      // .map((User? user) => _userFromFirebase(user));
      .map(_userFromFirebaseWithFirestoreDetails); // More concise than above

  //Create local UserModel object based on FirebaseUser
  UserModel _userFromFirebaseWithFirestoreDetails(User? user) {
    if (user == null) {
      return UserModel(
        uid: 'null',
        email: 'null',
        username: 'null',
        displayName: 'null',
        isEntertainer: false,
        isLive: false,
      );
    }

    // Get additional user details from cloud firestore
    _firestoreDatabase = FirestoreDatabase(uid: user.uid);
    var userDetails = _firestoreDatabase.getUserDetails();
    userDetails.then((e) {
      if (e.containsKey('username')) {
        _username = e['username'];
      } else if (e.containsKey('is_entertainer')) {
        _isEntertainer = e['is_entertainer'];
      } else if (e.containsKey('is_live')) {
        _isLive = e['is_live'];
      }
    });

    return UserModel(
      uid: user.uid,
      email: user.email,
      username: _username,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL,
      isEntertainer: _isEntertainer,
      isLive: _isLive,
    );
  }

  // Stream<Request> get requests => _auth.authStateChanges().map(_requestsFromFirebase);
  //
  // Request _requestsFromFirebase(User? user) {
  //   if (user == null) {
  //     return Request(
  //       uid: 'null',
  //       artist: 'null',
  //       title: 'null',
  //       notes: 'null',
  //       requesterId: 'null',
  //       entertainerId: 'null',
  //       played: false,
  //       timestamp: Timestamp.now(),
  //     );
  //   }
  //
  //   return Request();
  //
  // }

  //Method for new user registration using email and password
  Future<UserModel> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
    bool isEntertainer,
  ) async {
    try {
      _status = Status.registering;
      notifyListeners();
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _firestoreDatabase = FirestoreDatabase(uid: result.user!.uid);

      _firestoreDatabase.setUser(
        UserModel(
          uid: result.user!.uid,
          email: email,
          username: username,
          photoUrl: 'https://i.stack.imgur.com/l60Hf.png', // stock for now
          isEntertainer: isEntertainer,
          isLive: false,
        ),
      );

      _firestoreDatabase.setUsername(
        UsernameModel(
          uid: result.user!.uid,
          username: username,
        ),
      );

      return _userFromFirebaseWithFirestoreDetails(result.user);
    } catch (e) {
      print("Error on the new user registration = " + e.toString());
      _status = Status.unauthenticated;
      notifyListeners();
      return UserModel(
        uid: 'null',
        username: 'null',
        isEntertainer: isEntertainer,
        isLive: false,
      );
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

  Future<String> updateUserProfileImage({
    required String userUid,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);

      UserModel _user =
          UserModel.fromSnap(await _firestoreDatabase.getUserData());

      UserModel _newUser = UserModel(
        uid: _user.uid,
        email: _user.email,
        username: _user.username,
        displayName: _user.displayName,
        phoneNumber: _user.phoneNumber,
        photoUrl: photoUrl,
        isEntertainer: _user.isEntertainer,
        isLive: _user.isLive,
      );

      await _firestoreDatabase.setUser(_newUser);

      res = 'success';
    } catch (e) {
      return e.toString();
    }

    return res;
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
