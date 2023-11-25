// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final VoidCallback? onPressedOk;
  final VoidCallback? onPressedCancel;

  const MessageBox(
      {super.key,
      required this.title,
      required this.content,
      this.onPressedOk,
      this.onPressedCancel,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
          icon: Icon(icon), onPressed: () async => await show(context)),
    );
  }

  Future<void> show(BuildContext context) async {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Icon(icon),
            title: Text(title),
            content: Text(content, textAlign: TextAlign.center,),
            actions: [
              if (onPressedCancel != null) ...[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("Cancel"))
              ],
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Ok")),
            ],
          );
        },
      );
    } else {
      return showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(title),
            content: Text(content, textAlign: TextAlign.center,),
              actions: [
                if (onPressedCancel != null) ...[
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("Cancel"))
                ],
                CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Ok")),
              ],
            );
          });
    }
  }
}
