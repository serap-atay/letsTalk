// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum FormType { Register, Login }

enum TabItem { Users, Chats,Profile }

class TabItemData {
  final String title ;
  final IconData iconData;

  TabItemData({required this.title, required this.iconData});


  static Map<TabItem ,TabItemData> allTabs = {
    TabItem.Users : TabItemData(
        title: "Users",
        iconData: Icons.supervised_user_circle_rounded),
    TabItem.Chats : TabItemData(
        title: "Chats",
        iconData: Icons.chat_sharp),
    TabItem.Profile : TabItemData(
        title: "Profile",
        iconData: Icons.account_circle),
  };
}