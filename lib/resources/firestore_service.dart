import 'package:cloud_firestore/cloud_firestore.dart';

/*
This class represent all possible CRUD operations for FirebaseFirestore.
It contains all generic implementation needed based on the provided document
path and documentID,since most of the time in FirebaseFirestore design, we will have
documentID and path for any document and collections.
 */
class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<Map<String, dynamic>> getUserDetails({
    required String uid,
  }) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (querySnapshot.exists) {
      return querySnapshot.data()!;
    }
    return {};
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserSnap(
      {required String path}) async {
    var userSnap = await FirebaseFirestore.instance.doc(path).get();
    return userSnap;
  }

  Future<List<String>> fetchUsernamesInUse() async {
    List<String> usernames = [];
    final querySnapshot =
        await FirebaseFirestore.instance.collection('usernames').get().then(
              (snapshot) => {
                snapshot.docs.map((doc) {
                  usernames.add(doc['username'] as String);
                }),
              },
            );
    return usernames;
  }

  Future<void> setUser({
    required String userPath,
    required Map<String, dynamic> userData,
    required String usernamePath,
    required Map<String, dynamic> usernameData,
    bool merge = false,
  }) async {
    var reference = FirebaseFirestore.instance.doc(userPath);
    print('$userPath: $userData');
    await reference.set(userData);
    reference = FirebaseFirestore.instance.doc(usernamePath);
    print('$usernamePath: $usernameData');
    await reference.set(usernameData);
  }

  Future<void> set({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  //

  Future<void> bulkSet({
    required String path,
    required List<Map<String, dynamic>> datas,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    final batchSet = FirebaseFirestore.instance.batch();

    //    for()
    //    batchSet.

    print('$path: $datas');
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> entertainerSnapshotStream(
      {required String path}) {
    return FirebaseFirestore.instance
        .collection(path)
        // .where('is_entertainer', isEqualTo: true)
        .snapshots();
  }

  // TODO make sure orderBy shows most recent at top!
  Stream<QuerySnapshot<Map<String, dynamic>>> requestSnapshotStream(
      {required String path}) {
    return FirebaseFirestore.instance
        .collection(path)
        .orderBy('timestamp')
        .snapshots();
  }

  Stream<List<T>> entertainerCollectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(
                snapshot.data() as Map<String, dynamic>,
              ))
          .where((value) =>
              value != null) // TODO Figure out how to sort out requesters
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        builder(snapshot.data() as Map<String, dynamic>, snapshot.id));
  }

  Stream<T> entertainerStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots =
        reference.snapshots().where((event) {
      if (event.get('is_entertainer') == true) {
        return true;
      }
      return false;
    });
    return snapshots.map((snapshot) =>
        builder(snapshot.data() as Map<String, dynamic>, snapshot.id));
  }
}
