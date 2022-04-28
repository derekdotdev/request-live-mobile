import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:request_live/models/username_model.dart';

import '../models/request.dart';
import '../models/user_model.dart';
import '../models/username_model.dart';
import 'firestore_path.dart';
import 'firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

/*
This is the main class access/call for any UI widgets that require to perform
any CRUD activities operation in FirebaseFirestore database.
This class work hand-in-hand with FirestoreService and FirestorePath.

Notes:
For cases where you need to have a special method such as bulk update specifically
on a field, then is ok to use custom code and write it here. For example,
setAllTodoComplete is require to change all todos item to have the complete status
changed to true.

 */

// TODO go through this and remove all unused methods!

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _firestoreService = FirestoreService.instance;

  Future<Map<String, dynamic>> getUserDetails() async {
    var userDetails = await _firestoreService.getUserDetails(uid: uid);
    return userDetails;
  }

  // Method to retrieve user data for profile screen (in use)
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final userSnap =
        await _firestoreService.getUserSnap(path: FirestorePath.user(uid));
    return userSnap;
  }

  Future<List<String>> fetchUsernamesInUse() async {
    var usernames = await _firestoreService.fetchUsernamesInUse();
    return usernames;
  }

  // TODO address this!
  // Not used yet. Possibly better option than downloading a list of existing usernames to device
  // (along with preventing race condition by setting security rules
  // to prevent username node from being used more than once)
  void checkUsernamesInUse(String checkUsername) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestorePath.username(checkUsername))
        // .orderBy('username')
        .where('username', isEqualTo: checkUsername)
        .get();
  }

  Future<void> setUsername(UsernameModel username) async {
    await _firestoreService.set(
      path: FirestorePath.username(username.username),
      data: username.toMap(),
    );
  }

  // Method to create user
  Future<void> setUser(UserModel user) async => await _firestoreService.set(
        path: FirestorePath.user(user.uid),
        data: user.toMap(),
      );

  // Method to create/update requestModel
  Future<void> setRequest(Request request) async => await _firestoreService.set(
        path: FirestorePath.request(request.entertainerId, request.uid),
        data: request.toMap(),
      );

  // Methods to delete requests via Request and Request Id
  Future<void> deleteRequest(Request request) async {
    await _firestoreService.deleteData(
        path: FirestorePath.request(uid, request.uid));
  }

  Future<void> deleteRequestById(String requestId) async {
    await _firestoreService.deleteData(
        path: FirestorePath.request(uid, requestId));
  }

  // Method to retrieve all

  // Method to retrieve all entertainers for feed screen (in use)
  Stream<QuerySnapshot<Map<String, dynamic>>> entertainerSnapshotStream() =>
      _firestoreService.entertainerSnapshotStream(
        path: FirestorePath.users(),
      );

  Stream<List<UserModel>> entertainerCollectionStream() =>
      _firestoreService.entertainerCollectionStream(
        path: FirestorePath.users(),
        builder: (data) => UserModel.fromMap(data, uid),
      );

  // Method to retrieve all requests made to the same entertainer based on uid
  Stream<List<Request>> requestsStream() => _firestoreService.collectionStream(
        path: FirestorePath.requests(uid),
        builder: (data, documentId) => Request.fromMap(data, documentId),
      );

  // Method to retrieve all requests made to the same entertainer based on uid
  Stream<QuerySnapshot<Map<String, dynamic>>> requestSnapshotStream() =>
      _firestoreService.requestSnapshotStream(
        path: FirestorePath.requests(uid),
      );

  // Method to mark all requests as played
  Future<void> setAllRequestsPlayed() async {
    final batchUpdate = FirebaseFirestore.instance.batch();

    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestorePath.requests(uid))
        .get();

    for (DocumentSnapshot ds in querySnapshot.docs) {
      batchUpdate.update(ds.reference, {'played': true});
    }

    await batchUpdate.commit();
  }

  Future<void> deleteAllPlayedRequests() async {
    final batchDelete = FirebaseFirestore.instance.batch();

    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestorePath.requests(uid))
        .where('played', isEqualTo: true)
        .get();

    for (DocumentSnapshot ds in querySnapshot.docs) {
      batchDelete.delete(ds.reference);
    }
    await batchDelete.commit();
  }
}
