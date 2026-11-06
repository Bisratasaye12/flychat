import 'package:flutter/material.dart';
import 'package:flychat/colors.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/screens/mobile_chat_screen.dart';
import 'package:flychat/services/chat_repository.dart';
import 'package:flychat/widgets/contacts_list.dart';

class MobileScreenLayout extends StatelessWidget {
  final ChatUser me;
  final ChatRepository chats;
  final VoidCallback onSignOut;

  const MobileScreenLayout({
    super.key,
    required this.me,
    required this.chats,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: const Text('flychat',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: onSignOut,
          ),
        ],
      ),
      body: ContactLists(
        contacts: chats.contacts(me.uid),
        onSelect: (contact) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              MobileChatScreen(me: me, contact: contact, chats: chats),
        )),
      ),
    );
  }
}
