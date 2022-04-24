class UsernameModel {
  String uid;
  String username;

  UsernameModel({
    required this.uid,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
    };
  }

  factory UsernameModel.fromMap(Map<String, dynamic> data, String documentId) {
    String uid = data['uid'];
    String username = data['username'];

    return UsernameModel(
      uid: uid,
      username: username,
    );
  }
}
