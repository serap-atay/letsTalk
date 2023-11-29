// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letstalk/data/entity/user.dart';
import 'package:letstalk/ui/cubit/profileCubit.dart';
import 'package:letstalk/ui/widget/customCardWidget.dart';
import 'package:letstalk/ui/widget/customMessageBox.dart';

class ProfilePage extends StatefulWidget {
  final UserModel currentUser;
  const ProfilePage({super.key, required this.currentUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  File? image;
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    emailController.text = currentUser.email;
    userNameController.text = currentUser.username;
  }

  void chooseCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      MessageBox(
          content: e.code, icon: Icons.error, title: "Failed to pick image");
    }
  }

  void chooseGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      MessageBox(
          content: e.code, icon: Icons.error, title: "Failed to pick image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: (context),
                    builder: (context) {
                      return SizedBox(
                        height: 160,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera),
                              title: const Text("Choose camera"),
                              onTap: () {
                                chooseCamera();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text("Choose gallery"),
                              onTap: () {
                                chooseGallery();
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: SizedBox(
                height: 80,
                width: 80,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: (image == null)
                      ? (widget.currentUser.profileImage == "add-user.png")
                          ? const AssetImage("images/add-user.png")
                              as ImageProvider
                          : NetworkImage(widget.currentUser.profileImage)
                      : FileImage(image!),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  label: const Text("Email"),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade900),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0))),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                  )),
              onEditingComplete: () {},
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: userNameController,
              decoration: InputDecoration(
                  label: const Text("User Name"),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade900),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0))),
                  prefixIcon: const Icon(Icons.person)),
              onEditingComplete: () {},
            ),
            const SizedBox(
              height: 10,
            ),
            CustomCard(
              onPress: () {
                _updateUserName(currentUser.userId, userNameController.text);
                updateProfilePhoto();
              },
              title: "Save",
              color: Colors.blue.shade900,
              textColor: Colors.white,
              textSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserName(String userId, String username) async {
    if (username.toLowerCase().toString() == currentUser.username.toLowerCase().toString()) {
       const MessageBox(
          content: "You haven't made any changes",
          icon: Icons.error,
          title: "An Error Occurred").show(context);
    } else {
            try {
        await context.read<ProfileCubit>().updateUserName(userId, username);
        currentUser.username = userNameController.text;
      } on PlatformException catch (e) {
        MessageBox(
            content: e.code, icon: Icons.error, title: "An Error Occurred").show(context);
      }

    }
  }

  void updateProfilePhoto() async {
    if (image != null) {
      try {
        await context
            .read<ProfileCubit>()
            .updateProfilePhoto(currentUser.userId, "profile", image!);
      } on PlatformException catch (e) {
        MessageBox(
            content: e.code, icon: Icons.error, title: "An Error Occurred").show(context);
      }
    }
  }
}
