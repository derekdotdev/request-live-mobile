import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String? email;
  String username;
  String? displayName;
  String? phoneNumber;
  String? photoUrl;
  bool isEntertainer;
  bool isLive;

  UserModel({
    required this.uid,
    this.email,
    required this.username,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    required this.isEntertainer,
    required this.isLive,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'display_name': displayName,
      'phone_number': phoneNumber,
      'photo_url': photoUrl,
      'is_entertainer': isEntertainer,
      'is_live': isLive,
    };
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      username: snapshot['username'],
      displayName: snapshot['display_name'],
      phoneNumber: snapshot['phone_number'],
      photoUrl: snapshot['photo_url'],
      isEntertainer: snapshot['is_entertainer'],
      isLive: snapshot['is_live'],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    String uid = data['uid'];
    String email = data['email'];
    String username = data['username'];
    String displayName = data['display_name'];
    String phoneNumber = data['phone_number'];
    String photoUrl = data['photo_url'];
    bool isEntertainer = data['is_entertainer'];
    bool isLive = data['is_live'];

    return UserModel(
      uid: uid,
      email: email,
      username: username,
      displayName: displayName,
      phoneNumber: phoneNumber,
      photoUrl: photoUrl,
      isEntertainer: isEntertainer,
      isLive: isLive,
    );
  }
}
