// ignore_for_file: file_names, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/data/entity/message.dart';
import 'package:letstalk/ui/cubit/allChatCubit.dart';
import 'package:letstalk/ui/cubit/messageCubit.dart';
import 'package:letstalk/ui/widget/messageBox.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String receiverId;
  const ChatPage({Key? key, required this.userId, required this.receiverId})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  List<Message> list = [];

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        leading: IconButton(
            onPressed: () {
              getAllChats();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: BlocBuilder<MessageCubit, List<Message>>(
                  builder: (context, list) {
                if (list.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      var message = list[index];
                      return Align(
                        alignment: message.isFromMe == "true"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                                color: message.isFromMe == "true"
                                    ? const Color.fromARGB(255, 143, 172, 206)
                                    : const Color.fromARGB(82, 209, 205, 205),
                                margin: const EdgeInsets.only(
                                    right: 6.0, left: 6.0, bottom: 4.0),
                                shape: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: message.isFromMe == "true"
                                          ? const Color.fromARGB(
                                              255, 143, 172, 206)
                                          : const Color.fromARGB(
                                              82, 209, 205, 205)),
                                ),
                                child: IntrinsicWidth(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20.0,
                                        top: 0.0,
                                        bottom: 0.0,
                                        right: 20.0),
                                    visualDensity: const VisualDensity(
                                        vertical: -4, horizontal: -4),
                                    dense: true,
                                    title: Text(
                                      message.message,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      "${message.createdDate.toDate().hour}:${message.createdDate.toDate().minute}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center();
                }
              }),
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    height: 40,
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, left: 20.0),
                          hintText: "Message",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade900),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          )),
                    ),
                  ),
                )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      side: BorderSide(color: Colors.blue.shade900),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      minimumSize: const Size(10, 40)),
                  onPressed: () {
                    saveMessage();
                    getMessages();
                    messageController.clear();
                  },
                  child: const Icon(
                    Icons.arrow_right_sharp,
                    color: Colors.white,
                    size: 30.0,
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  void saveMessage() async {
    Message message = Message(
        messageId: widget.userId,
        fromWho: widget.userId,
        toWho: widget.receiverId,
        isFromMe: "true",
        createdDate: Timestamp.fromDate(DateTime.now()),
        message: messageController.text);

    try {
      await context.read<MessageCubit>().saveMessage(message);
    } on PlatformException catch (e) {
      MessageBox(
          content: e.code, icon: Icons.error, title: "An Error Occurred").show(context);
    }
  }

  void getMessages() async {
    try {
      await context
          .read<MessageCubit>()
          .getAllMessages(widget.userId, widget.receiverId, widget.userId);
    } on PlatformException catch (e) {
      MessageBox(
          content: e.code, icon: Icons.error, title: "An Error Occurred").show(context);
    }
  }

  void getAllChats() async {
    try {
      await context.read<AllChatCubit>().getAllChats(widget.userId);
    } on PlatformException catch (e) {
      MessageBox(
          content: e.code, icon: Icons.error, title: "An Error Occurred").show(context);
    }
  }
}
