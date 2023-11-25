// ignore_for_file: file_names
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/data/entity/user.dart';
import 'package:letstalk/data/services/firebaseDbService.dart';
import 'package:letstalk/locator.dart';

class UsersCubit extends Cubit<List<UserModel>> {
  UsersCubit() : super([]);

  final _locator = locator<FirebaseDbService>();

  Future<void> getAllUsers() async {
    var list = <UserModel>[];
    var resp = await _locator.getAllUsers();
    list.addAll(resp);
    emit(list);
  }
}
