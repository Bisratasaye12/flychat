import 'package:flutter/material.dart';
import 'package:flychat/colors.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/widgets/avatar.dart';

class WebChatAppBar extends StatelessWidget {
  final ChatUser contact;

  const WebChatAppBar({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: webAppBarColor,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Avatar(user: contact, radius: 20),
          const SizedBox(width: 12),
          Text(contact.name, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
