/*
This class defines all the possible read/write locations from the FirebaseFirestore database.
In the future, any new path can be added here.
This class works together with FirestoreService and FirestoreDatabase.
 */

class FirestorePath {
  static String request(String entertainerId, String requestId) =>
      'entertainers/$entertainerId/request/$requestId';
  static String requests(String entertainerId) =>
      'entertainers/$entertainerId/requests';
}
