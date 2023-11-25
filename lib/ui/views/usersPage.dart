// ignore_for_file: file_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/data/entity/user.dart';
import 'package:letstalk/ui/cubit/messageCubit.dart';
import 'package:letstalk/ui/cubit/usersCubit.dart';
import 'package:letstalk/ui/views/chatPage.dart';
import 'package:letstalk/ui/widget/messageBox.dart';

class UsersPage extends StatefulWidget {
  final UserModel currentUser;
  const UsersPage({super.key, required this.currentUser});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onrefresh(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocBuilder<UsersCubit, List<UserModel>>(builder: (context, list) {
            if (list.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      var user = list[index];
                      if (user.userId != widget.currentUser.userId) {
                        return GestureDetector(
                          onTap: () async {
                            context.read<MessageCubit>().getAllMessages(
                                widget.currentUser.userId,
                                user.userId,
                                widget.currentUser.userId);

                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        userId: widget.currentUser.userId,
                                        receiverId: user.userId)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        (user.profileImage == "add-user.png")
                                            ? const AssetImage(
                                                    "images/add-user.png")
                                                as ImageProvider
                                            : NetworkImage(user.profileImage),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.username,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(user.email),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Center();
                      }
                    }),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          })
        ],
      ),
    );
  }

  void getAllUsers() async {
    try {
      await context.read<UsersCubit>().getAllUsers();
    } on PlatformException catch (e) {
      MessageBox(
          content: e.code, icon: Icons.error, title: "An Error Occurred").show(context);
    }
  }

  _onrefresh() async {
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        getAllUsers();
      });
    });
  }
}
