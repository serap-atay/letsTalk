// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/data/entity/chats.dart';
import 'package:letstalk/data/repository/userRepository.dart';
import 'package:letstalk/locator.dart';

class AllChatCubit extends Cubit<List<Chats>> {
  AllChatCubit() : super([]);

  final _repository = locator<UserRepository>();

  Future<void> getAllChats(String userId) async {
    var list = <Chats>[];
    var resp = await _repository.getAllChats(userId);
    list.addAll(resp);
    emit(list);
  }
}
