// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letstalk/enums/enums.dart';

// ignore: must_be_immutable
class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar(
      {super.key,
      required this.currenTab,
      required this.selectedTabItem,
      required this.pages,
      required this.navigatorKeys, required this.userId});

  final TabItem currenTab;
  final ValueChanged<TabItem> selectedTabItem;
  final Map<TabItem, Widget> pages;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKeys[currenTab] != null) {
          if (navigatorKeys[currenTab]!.currentState != null) {
            return !await navigatorKeys[currenTab]!.currentState!.maybePop();
          } else {
            return Future.value(true);
          }
        } else {
          return Future.value(true);
        }
      },
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.transparent,
          activeColor: Colors.blue.shade900,
          items: [
            _bottomNavItem(TabItem.Users),
            _bottomNavItem(TabItem.Chats),
            _bottomNavItem(TabItem.Profile)
          ],
          onTap: (index) async {
            selectedTabItem(TabItem.values[index]);
            // if (TabItem.values[index] == TabItem.Chats) {
            //   await context.read<AllChatCubit>().getAllChats(userId);
            // } else if (TabItem.values[index] == TabItem.Users) {
            //   await context.read<UsersCubit>().getAllUsers();
            // }
          },
        ),
        tabBuilder: (BuildContext context, int index) {
          final page = pages[TabItem.values[index]];
          if (page != null) {
            return CupertinoTabView(
              navigatorKey: navigatorKeys[TabItem.values[index]],
              builder: (context) {
                return page;
              },
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }

  BottomNavigationBarItem _bottomNavItem(TabItem tabItem) {
    final tabitem = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
        icon: Icon(tabitem!.iconData), label: tabitem.title);
  }
}
