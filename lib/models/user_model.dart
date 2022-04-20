class UserModel {
  final String uid;
  String? email;
  String? displayName;
  String? phoneNumber;
  String? photoUrl;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
  });

  // final String uid;
  // String? email;
  // String? displayName;
  // String? phoneNumber;
  // String? photoUrl;
  // Future<bool>? isEntertainer;
  //
  // UserModel({
  //   required this.uid,
  //   this.email,
  //   this.displayName,
  //   this.phoneNumber,
  //   this.photoUrl,
  //   this.isEntertainer,
  // });
}
