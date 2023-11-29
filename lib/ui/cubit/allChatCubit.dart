// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/data/entity/chats.dart';

class AllChatCubit extends Cubit<List<Chats>> {
  AllChatCubit() : super([]);

  final _firebaseDb = FirebaseFirestore.instance;

  Future<void> getAllChats(String userId) async {
    _firebaseDb
        .collection("chats")
        .where("ownerUserId", isEqualTo: userId)
        .snapshots()
        .listen((event) {
      var list = <Chats>[];
      var docs = event.docs;
      for (var doc in docs) {
        list.add(Chats.fromJson(doc.data()));
      }
      emit(list);
    });
  }
}
