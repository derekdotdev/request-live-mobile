import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  String? email;
  String? displayName;
  String? phoneNumber;
  String? photoUrl;
  bool? isEntertainer;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.isEntertainer,
  });
}
