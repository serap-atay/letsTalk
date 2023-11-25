import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String messageId;
  final String fromWho;
  final String toWho;
  String isFromMe;
  final String message;
  final Timestamp createdDate;

  Message(
      {required this.messageId,
      required this.fromWho,
      required this.toWho,
      required this.isFromMe,
      required this.createdDate,
      required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        messageId: json["messageId"] as String,
        fromWho: json["fromWho"] as String,
        toWho: json["toWho"] as String,
        isFromMe: json["isFromMe"] as String,
        message: json["message"],
        createdDate: (json["createdDate"]));
  }

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "fromWho": fromWho,
      "toWho": toWho,
      "isFromMe": isFromMe,
      "message": message,
      "createdDate": createdDate,
    };
  }
}
