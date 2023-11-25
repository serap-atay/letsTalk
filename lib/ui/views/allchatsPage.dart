// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/data/entity/chats.dart';
import 'package:letstalk/data/entity/user.dart';
import 'package:letstalk/ui/cubit/allChatCubit.dart';
import 'package:letstalk/ui/views/chatPage.dart';
import 'package:letstalk/ui/widget/messageBox.dart';

class AllChatsPage extends StatefulWidget {
  final UserModel currentUser;
  const AllChatsPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<AllChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<AllChatsPage> {
  @override
  void initState() {
    super.initState();
    _getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onrefresh(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<AllChatCubit, List<Chats>>(builder: (context, list) {
              if (list.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        var chats = list[index];
                        if (chats.ownerUserId == widget.currentUser.userId) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          userId: widget.currentUser.userId,
                                          receiverId: chats.receiverUserId)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          (chats.receiverProfilePhoto ==
                                                  "add-user.png")
                                              ? const AssetImage(
                                                      "images/add-user.png")
                                                  as ImageProvider
                                              : NetworkImage(
                                                  chats.receiverProfilePhoto),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chats.receiverUserName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(chats.lastMessage),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${chats.lastMessageDate.day}/${chats.lastMessageDate.month}/${chats.lastMessageDate.year}",
                                    style: const TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                );
              } else {
                return const Center();
              }
            })
          ],
        ),
      ),
    );
  }

  _onrefresh() async {
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _getAllChats();
      });
    });
  }

  void _getAllChats() async {
    try {
      await context.read<AllChatCubit>().getAllChats(widget.currentUser.userId);
    } on PlatformException catch (e) {
      MessageBox(
          content: e.code, icon: Icons.error, title: "An Error Occurred");
    }
  }
}
