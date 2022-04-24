/*
This class defines all the possible read/write locations from the FirebaseFirestore database.
In the future, any new path can be added here.
This class works together with FirestoreService and FirestoreDatabase.
 */

// Paths to:
class FirestorePath {
  // Specific request sent to an entertainer
  static String request(String entertainerId, String requestId) =>
      'entertainers/$entertainerId/request/$requestId';

  // All requests sent to an entertainer
  static String requests(String entertainerId) =>
      'entertainers/$entertainerId/requests';

  // Specific user
  static String user(String uid) => 'users/$uid';

  // Specific username
  static String username(String username) => 'usernames/$username';

  // All usernames
  static String usernames(String username) => 'usernames/';
}
