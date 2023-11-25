// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/data/entity/message.dart';
import 'package:letstalk/data/repository/userRepository.dart';
import 'package:letstalk/locator.dart';

class MessageCubit extends Cubit<List<Message>> {
  MessageCubit() : super([]);
  final _firebaseDb = FirebaseFirestore.instance;
  final _repository = locator<UserRepository>();

  Future<void> getAllMessages(
      String userId, String receiverId, String messageId) async {
    var list = <Message>[];
    _firebaseDb
        .collection("chats")
        .doc("$userId-$receiverId")
        .collection("messages")
        .doc(userId)
        .collection("message")
        .orderBy("createdDate", descending: true)
        .snapshots()
        .listen((event) {
      list.clear();
      var docs = event.docs;
      for (var doc in docs) {
        list.add(Message.fromJson(doc.data()));
      }
      emit(list);
    });
  }

  Future<void> saveMessage(Message message) async {
    await _repository.saveMessages(message);
  }
}
