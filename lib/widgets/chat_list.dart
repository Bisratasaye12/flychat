import 'package:flutter/material.dart';
import 'package:flychat/models/message.dart';
import 'package:flychat/utils/format_time.dart';
import 'package:flychat/widgets/my_message_card.dart';
import 'package:flychat/widgets/sender_message_card.dart';

class ChatList extends StatelessWidget {
  final Stream<List<Message>> messages;
  final String myUid;

  const ChatList({super.key, required this.messages, required this.myUid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: messages,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Could not load messages.'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // newest at the bottom, list starts scrolled to it
        final items = snapshot.data!.reversed.toList();
        if (items.isEmpty) {
          return const Center(child: Text('No messages yet. Say hi!'));
        }

        return ListView.builder(
          reverse: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final message = items[index];
            final time = formatTime(message.sentAt);

            if (message.senderId == myUid) {
              return MyMessageCard(message: message.text, date: time);
            }
            return SenderMessageCard(message: message.text, date: time);
          },
        );
      },
    );
  }
}
