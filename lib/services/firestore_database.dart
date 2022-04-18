import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/request_model.dart';
import '../services/firestore_path.dart';
import '../services/firestore_service.dart';

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

class FirestoreDatabase {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;

  final _firestoreService = FirestoreService.instance;

  // Method to create/update requestModel
  Future<void> setRequest(RequestModel request) async =>
      await _firestoreService.set(
        path: FirestorePath.request(uid, request.id),
        data: request.toMap(),
      );

  // Method to delete request entry
  Future<void> deleteRequest(RequestModel request) async {
    await _firestoreService.deleteData(
        path: FirestorePath.request(uid, request.id));
  }

  // Method to retrieve all requests made to the same entertainer based on uid
  Stream<List<RequestModel>> requestsStream() =>
      _firestoreService.collectionStream(
        path: FirestorePath.requests(uid),
        builder: (data, documentId) => RequestModel.fromMap(data, documentId),
      );

  // Method to mark all requests as played
  Future<void> setAllRequestsPlayed() async {
    final batchUpdate = FirebaseFirestore.instance.batch();

    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestorePath.requests(uid))
        .get();

    for (DocumentSnapshot ds in querySnapshot.docs) {
      batchUpdate.update(ds.reference, {'complete': true});
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
