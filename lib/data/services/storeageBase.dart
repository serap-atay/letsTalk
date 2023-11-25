// ignore_for_file: file_names

import 'dart:io';

abstract class StrorageBase {
  Future<String> uploadFile(
      String userID, String fileType, File yuklenecekDosya);
}
