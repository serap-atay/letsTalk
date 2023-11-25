// ignore_for_file: file_names
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/data/repository/userRepository.dart';
import 'package:letstalk/locator.dart';

class ProfileCubit extends Cubit<void> {
  ProfileCubit() : super(null);

  final _repository = locator<UserRepository>();

  Future<void> updateUserName(String userId, String userName) async {
    await _repository.updateUserName(userId, userName);
  }

  Future<void> updateProfilePhoto(
      String userId, String fileType, File uploadImage) async {
    await _repository.uploadProfileImage(userId, fileType, uploadImage);
  }
}
