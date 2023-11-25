// ignore_for_file: file_names

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/data/repository/userRepository.dart';
import 'package:letstalk/locator.dart';
import 'package:letstalk/ui/cubit/authState.dart';

class AuthCubit extends Cubit<AuthState> {
  final _locator = locator<UserRepository>();
  AuthCubit() : super(AuthInitial());


  Future<void> register(String email, String password) async {
    try {
      var user = await _locator.createWithCredential(email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(NothAuthenticated());
      }
    } on PlatformException catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      var user = await _locator.signInWithCredential(email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(NothAuthenticated());
      }
    } on PlatformException catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> currentUser() async {
    try {
      var user = await _locator.currentUser();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(NothAuthenticated());
      }
    } on PlatformException catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

    Future<void> signInWitFacebook() async {
    try {
      var user = await _locator.signInWitFacebook();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(NothAuthenticated());
      }
    } on PlatformException catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

      Future<void> signInWitGoogle() async {
    try {
      var user = await _locator.signInWitGoogle();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(NothAuthenticated());
      }
    } on PlatformException catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
       await _locator.signOut();
        emit(NothAuthenticated());
      
    } on PlatformException catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
