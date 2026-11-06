import 'package:flutter/material.dart';
import 'package:flychat/colors.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/widgets/avatar.dart';

class WebProfileBar extends StatelessWidget {
  final ChatUser me;
  final VoidCallback onSignOut;

  const WebProfileBar({super.key, required this.me, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: dividerColor)),
        color: webAppBarColor,
      ),
      child: Row(
        children: [
          Avatar(user: me, radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              me.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: onSignOut,
            icon: const Icon(Icons.logout, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
