// ignore_for_file: file_names

import 'package:letstalk/data/entity/message.dart';
import 'package:letstalk/data/entity/user.dart';

abstract class DbBase {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser(String userId);
  Future<List<UserModel>> getAllUsers();
  Future<bool> updateUserName(String userId, String userName);
  Future<void> updateProfileImage(String userId, String uploadImage);
  Future<bool> saveMessages(Message message);
}
