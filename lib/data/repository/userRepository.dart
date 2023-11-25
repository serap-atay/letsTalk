// ignore_for_file: file_names

import 'dart:io';

import 'package:letstalk/data/entity/chats.dart';
import 'package:letstalk/data/entity/message.dart';
import 'package:letstalk/data/entity/user.dart';
import 'package:letstalk/data/services/authBase.dart';
import 'package:letstalk/data/services/firebaseAuthService.dart';
import 'package:letstalk/data/services/firebaseDbService.dart';
import 'package:letstalk/data/services/firebaseStroreageService.dart';
import 'package:letstalk/locator.dart';

class UserRepository implements AuthBase {
  final _authService = locator<FirebaseAuthService>();
  final _dbSevice = locator<FirebaseDbService>();
  final _storage = locator<FirebaseStorageService>();
  UserModel? user;

  @override
  Future<UserModel?> createWithCredential(String email, String password) async {
    var firebaseUser = await _authService.createWithCredential(email, password);
    if (firebaseUser != null) {
      await _dbSevice.saveUser(firebaseUser);
      user = await _dbSevice.getUser(firebaseUser.userId);
    }
    return user;
  }

  @override
  Future<UserModel?> currentUser() async {
    var firebaseUser = await _authService.currentUser();
    if (firebaseUser != null) {
      user = await _dbSevice.getUser(firebaseUser.userId);
    }
    return user;
  }

  @override
  Future<UserModel?> signInWitFacebook() async {
    var firebaseUser = await _authService.signInWitFacebook();
    if (firebaseUser != null) {
      await _dbSevice.saveUser(firebaseUser);
      user = await _dbSevice.getUser(firebaseUser.userId);
    }
    return user;
  }

  @override
  Future<UserModel?> signInWitGoogle() async {
    var firebaseUser = await _authService.signInWitGoogle();
    if (firebaseUser != null) {
      await _dbSevice.saveUser(firebaseUser);
      user = await _dbSevice.getUser(firebaseUser.userId);
    }
    return user;
  }

  @override
  Future<UserModel?> signInWithCredential(String email, String password) async {
    var firebaseUser = await _authService.signInWithCredential(email, password);
    if (firebaseUser != null) {
      user = await _dbSevice.getUser(firebaseUser.userId);
    }
    return user;
  }

  @override
  Future<bool> signOut() async {
    return await _authService.signOut();
  }

  Future<List<UserModel>> getAllUsers() async {
    return await _dbSevice.getAllUsers();
  }

  Future<bool> updateUserName(String userId, String userName) async {
    return await _dbSevice.updateUserName(userId, userName);
  }

  Future<String> uploadProfileImage(
      String userId, String fileType, File uploadImage) async {
    var url = await _storage.uploadFile(userId, fileType, uploadImage);
    await _dbSevice.updateProfileImage(userId, url);
    return url;
  }

  Future<bool> saveMessages(Message message ) async {
    await _dbSevice.saveMessages(message);
    return true;
  }

  Future<List<Chats>> getAllChats(String userId) async {
    return await _dbSevice.getAllChats(userId);
  }
}
