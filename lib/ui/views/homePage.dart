// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/data/entity/user.dart';
import 'package:letstalk/ui/cubit/authCubit.dart';
import 'package:letstalk/ui/views/allchatsPage.dart';
import 'package:letstalk/ui/views/profilePage.dart';
import 'package:letstalk/ui/views/usersPage.dart';
import 'package:letstalk/ui/widget/customMessageBox.dart';

class HomePage extends StatefulWidget {
  final UserModel currentUser;

  const HomePage({super.key, required this.currentUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //late Map<TabItem, Widget> allpages;
  var allpages = <Widget>[];
  int selectedIndex = 0;
  String title = "Users";
  bool isActive = true;
  
  void signOut() async {
    try {
      await context.read<AuthCubit>().signOut();
    } on PlatformException catch (e) {
      MessageBox(
          content: e.code, icon: Icons.error, title: "An Error Occurred").show(context);
    }
  }

  @override
  void initState() {
    super.initState();
    allpages = [
      UsersPage(currentUser: widget.currentUser),
      AllChatsPage(currentUser: widget.currentUser),
      ProfilePage(currentUser: widget.currentUser)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          title == "Profile"
              ? IconButton(
                  icon: const Icon(Icons.power_settings_new_outlined),
                  onPressed: () {
                    signOut();
                  })
              : const Text(""),
        ],
      ),
      body: allpages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
              label: "Users",
              icon: IconButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 0;
                      title = "Users";
                    });
                  },
                  icon: const Icon(Icons.supervised_user_circle_rounded))),
          BottomNavigationBarItem(
              label: "Chats",
              icon: IconButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 1;
                      title = "Chats";
                    });
                  },
                  icon: const Icon(Icons.chat_sharp))),
          BottomNavigationBarItem(
              label: "Profile",
              icon: IconButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 2;
                      title = "Profile";
                    });
                  },
                  icon: const Icon(Icons.account_circle))),
        ],
      ),
    );
  }
}
