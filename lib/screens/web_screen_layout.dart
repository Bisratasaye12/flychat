import 'package:flutter/material.dart';
import 'package:flychat/colors.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/services/chat_repository.dart';
import 'package:flychat/widgets/chat_input.dart';
import 'package:flychat/widgets/chat_list.dart';
import 'package:flychat/widgets/contacts_list.dart';
import 'package:flychat/widgets/web_chat_app_bar.dart';
import 'package:flychat/widgets/web_profile_bar.dart';

class WebScreenLayout extends StatefulWidget {
  final ChatUser me;
  final ChatRepository chats;
  final VoidCallback onSignOut;

  const WebScreenLayout({
    super.key,
    required this.me,
    required this.chats,
    required this.onSignOut,
  });

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  ChatUser? _selected;
  late final Stream<List<ChatUser>> _contacts =
      widget.chats.contacts(widget.me.uid);

  @override
  Widget build(BuildContext context) {
    final selected = _selected;

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 360,
            child: Column(
              children: [
                WebProfileBar(me: widget.me, onSignOut: widget.onSignOut),
                Expanded(
                  child: ContactLists(
                    contacts: _contacts,
                    selectedUid: selected?.uid,
                    onSelect: (contact) => setState(() => _selected = contact),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1, color: dividerColor),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/backgroundImage.png",
                      ),
                      fit: BoxFit.cover)),
              child: selected == null
                  ? const Center(child: Text('Pick a contact to start chatting'))
                  : Column(
                      // a new key per contact so the message stream resets
                      key: ValueKey(selected.uid),
                      children: [
                        WebChatAppBar(contact: selected),
                        Expanded(
                          child: ChatList(
                            messages: widget.chats
                                .messages(widget.me.uid, selected.uid),
                            myUid: widget.me.uid,
                          ),
                        ),
                        ChatInput(
                          onSend: (text) => widget.chats.sendMessage(
                            from: widget.me.uid,
                            to: selected.uid,
                            text: text,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
