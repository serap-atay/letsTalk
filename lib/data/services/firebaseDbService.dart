// ignore_for_file: file_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letstalk/data/entity/chats.dart';
import 'package:letstalk/data/entity/message.dart';
import 'package:letstalk/data/entity/user.dart';

import 'package:letstalk/data/services/dbBase.dart';

class FirebaseDbService implements DbBase {
  final _firebaseDb = FirebaseFirestore.instance;

  @override
  Future<UserModel?> getUser(String userId) async {
    UserModel? user;
    var resp = await _firebaseDb.collection("users").doc(userId).get();
    if (resp.data() != null) {
      return user = UserModel.fromJson(resp.data()!);
    } else {
      return user;
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    user.username= user.email.substring(0, user.email.indexOf('@')) +
                Random().nextInt(999).toString();
    var adduser = user.toMap();
    adduser["createdDate"] = FieldValue.serverTimestamp();
    adduser["updatedDate"] = FieldValue.serverTimestamp();
    await _firebaseDb.collection("users").doc(adduser["userId"]).set(adduser);
  }

  @override
  Future<void> updateProfileImage(String userId, String uploadImage) async {
    await _firebaseDb
        .collection("users")
        .doc(userId)
        .update({"profileImage": uploadImage});
  }

  @override
  Future<bool> updateUserName(String userId, String userName) async {
    var resp = await _firebaseDb
        .collection("users")
        .where("username", isEqualTo: userName)
        .get();
    if (resp.docs.length > 1) {
      return false;
    } else {
      await _firebaseDb
          .collection("users")
          .doc(userId)
          .update({"username": userName});
      return true;
    }
  }

  @override
  Future<bool> saveMessages(Message message) async {
    UserModel? user;
    await _firebaseDb
        .collection("chats")
        .doc("${message.fromWho}-${message.toWho}")
        .collection("messages")
        .doc(message.fromWho)
        .collection("message")
        .add(message.toMap());

     user = await getUser(message.toWho);
    if (user != null) {
      var chats = Chats(
          ownerUserId: message.fromWho,
          receiverUserId: message.toWho,
          lastMessage: message.message,
          lastMessageDate: message.createdDate.toDate(),
          receiverUserName: user.username,
          receiverProfilePhoto: user.profileImage);

      await _firebaseDb
          .collection("chats")
          .doc("${message.fromWho}-${message.toWho}")
          .set(chats.toMap());
    }

    message.isFromMe = "false";
    message.messageId = message.toWho;

    user = await getUser(message.fromWho);
    if (user != null) {
      await _firebaseDb
          .collection("chats")
          .doc("${message.toWho}-${message.fromWho}")
          .collection("messages")
          .doc(message.toWho)
          .collection("message")
          .add(message.toMap());

      var chats = Chats(
          ownerUserId: message.toWho,
          receiverUserId: message.fromWho,
          lastMessage: message.message,
          lastMessageDate: message.createdDate.toDate(),
          receiverUserName: user.username,
          receiverProfilePhoto: user.profileImage);
      await _firebaseDb
          .collection("chats")
          .doc("${message.toWho}-${message.fromWho}")
          .set(chats.toMap());
    }
    return true;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    var list = <UserModel>[];
    var resp = await _firebaseDb.collection("users").orderBy("username").get();
    for (var doc in resp.docs) {
      list.add(UserModel.fromJson(doc.data()));
    }
    return list;
  }

  @override
  Future<List<Chats>> getAllChats(String userId) async {
    var list = <Chats>[];
    var resp = await _firebaseDb
        .collection("chats")
        .where("ownerUserId", isEqualTo: userId)
        .get();
    var docs = resp.docs;
    for (var doc in docs) {
      list.add(Chats.fromJson(doc.data()));
    }
    return list;
  }
}
