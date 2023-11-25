import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  String username;
  final String email;
  final String profileImage;
  final String createdDate;
  final String updatedDate;

  UserModel(
      {required this.email,
      this.username = "",
      this.profileImage = "add-user.png",
      this.createdDate = "",
      this.updatedDate = "",
      required this.userId});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json["userId"] as String,
        username: json["username"] as String,
        email: json["email"] as String,
        profileImage: json["profileImage"] as String,
        createdDate: (json["createdDate"] as Timestamp).toDate().toString(),
        updatedDate: (json["updatedDate"] as Timestamp).toDate().toString());
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "username": username,
      "email": email,
      "profileImage": profileImage,
      "createdDate": createdDate,
      "updatedDate": updatedDate,
    };
  }
}
