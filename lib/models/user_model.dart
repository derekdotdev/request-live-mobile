class UserModel {
  String uid;
  String? email;
  String? displayName;
  bool isEntertainer;

  UserModel(
      {required this.uid,
      this.email,
      this.displayName,
      required this.isEntertainer});
}
