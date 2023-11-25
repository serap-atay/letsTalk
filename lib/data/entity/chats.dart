import 'package:cloud_firestore/cloud_firestore.dart';

class Chats {
  final String ownerUserId;
  final String receiverUserId;
  final String lastMessage;
  final DateTime lastMessageDate;
  final String receiverUserName;
  final String receiverProfilePhoto;

  Chats({required this.ownerUserId, required this.receiverUserId, required this.lastMessage, required this.lastMessageDate, required this.receiverUserName, required this.receiverProfilePhoto});

    factory Chats.fromJson(Map<String, dynamic> json) {
    return Chats(
        ownerUserId: json["ownerUserId"] as String,
        receiverUserId: json["receiverUserId"] as String,
        lastMessage: json["lastMessage"] as String,
        receiverUserName: json["receiverUserName"] as String,
        receiverProfilePhoto: json["receiverProfilePhoto"] as String,
        lastMessageDate: (json["lastMessageDate"] as Timestamp).toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      "ownerUserId": ownerUserId,
      "receiverUserId": receiverUserId,
      "lastMessage": lastMessage,
      "receiverUserName": receiverUserName,
      "receiverProfilePhoto": receiverProfilePhoto,
      "lastMessageDate": Timestamp.fromDate(lastMessageDate),
    };
  }
}