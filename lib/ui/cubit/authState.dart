// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:letstalk/data/entity/user.dart';





sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserModel user;

  const AuthSuccess(this.user);
}
final class NothAuthenticated extends AuthState {}

final class AuthFailure extends AuthState {
  final String errorMessage;

  const AuthFailure(this.errorMessage);
}