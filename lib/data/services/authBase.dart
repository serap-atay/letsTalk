// ignore_for_file: file_names

import 'package:letstalk/data/entity/user.dart';

abstract class AuthBase {
  Future<bool> signOut();
  Future<UserModel?> currentUser();
  Future<UserModel?> signInWithCredential(String email, String password);
  Future<UserModel?> createWithCredential(String email, String password);
  Future<UserModel?> signInWitFacebook();
  Future<UserModel?> signInWitGoogle();
}
