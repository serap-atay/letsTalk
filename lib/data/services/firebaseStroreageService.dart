// ignore_for_file: file_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:letstalk/data/services/storeageBase.dart';

class FirebaseStorageService implements StrorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  

  @override
  Future<String> uploadFile(
      String userID, String fileType, File yuklenecekDosya) async {
    Reference ref = _firebaseStorage
        .ref()
        .child(userID)
        .child(fileType)
        .child("profil_foto.png");

            UploadTask uploadTask = ref.putFile(yuklenecekDosya);

    // var url =
    //     await _firebaseStorage.ref().child(userID)
    //     .child(fileType).child("profil_foto.png").getDownloadURL();

    final snapshot = await uploadTask.whenComplete(() => null);

    final url = await snapshot.ref.getDownloadURL();

    return url;

    
  }
}
