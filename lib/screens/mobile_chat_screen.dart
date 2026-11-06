import 'package:flutter/material.dart';
import 'package:flychat/colors.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/services/chat_repository.dart';
import 'package:flychat/widgets/avatar.dart';
import 'package:flychat/widgets/chat_input.dart';
import 'package:flychat/widgets/chat_list.dart';

class MobileChatScreen extends StatelessWidget {
  final ChatUser me;
  final ChatUser contact;
  final ChatRepository chats;

  const MobileChatScreen({
    super.key,
    required this.me,
    required this.contact,
    required this.chats,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        titleSpacing: 0,
        title: Row(
          children: [
            Avatar(user: contact, radius: 18),
            const SizedBox(width: 10),
            Text(contact.name, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ChatList(
            messages: chats.messages(me.uid, contact.uid),
            myUid: me.uid,
          ),
        ),
        ChatInput(
          onSend: (text) =>
              chats.sendMessage(from: me.uid, to: contact.uid, text: text),
        ),
      ]),
    );
  }
}
