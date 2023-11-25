// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letstalk/data/entity/user.dart';
import 'package:letstalk/data/services/authbase.dart';

class FirebaseAuthService implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  @override
  Future<UserModel?> signInWitFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    if (loginResult.status == LoginStatus.success) {
      if (loginResult.accessToken != null) {
        UserCredential authResult = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(loginResult.accessToken!.token));
        _user = authResult.user;
      }
    }
    if (_user != null) {
      return UserModel(
          email: _user!.email.toString(), userId: _user!.uid.toString());
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> signInWitGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account != null) {
      GoogleSignInAuthentication authentication = await account.authentication;
      if (authentication.accessToken != null &&
          authentication.idToken != null) {
        UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
                accessToken: authentication.accessToken,
                idToken: authentication.idToken));
        _user = userCredential.user;
      }
    }
    if (_user != null) {
      return UserModel(
          email: _user!.email.toString(), userId: _user!.uid.toString());
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> createWithCredential(String email, String password) async {
    _user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (_user != null) {
      return UserModel(
          email: _user!.email.toString(), userId: _user!.uid.toString());
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithCredential(String email, String password) async {
    var user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      return UserModel(
          email: user.email.toString(), userId: user.uid.toString());
    } else {
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final loginResult = FacebookAuth.instance;
    await _firebaseAuth.signOut();
    await googleSignIn.signOut();
    await loginResult.logOut();

    return true;
  }

  @override
  Future<UserModel?> currentUser() async {
    _user = _firebaseAuth.currentUser;
    if (_user != null) {
      return UserModel(
          email: _user!.email.toString(), userId: _user!.uid.toString());
    } else {
      return null;
    }
  }
}
