import 'package:flutter/material.dart';
import 'package:flychat/colors.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/widgets/avatar.dart';

class ContactLists extends StatelessWidget {
  final Stream<List<ChatUser>> contacts;
  final ValueChanged<ChatUser> onSelect;
  final String? selectedUid;

  const ContactLists({
    super.key,
    required this.contacts,
    required this.onSelect,
    this.selectedUid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatUser>>(
      stream: contacts,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Could not load contacts.'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!;
        if (users.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Nobody else is here yet. Invite a friend to sign up.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.only(top: 10.0),
          itemCount: users.length,
          separatorBuilder: (context, index) =>
              const Divider(color: dividerColor, indent: 85),
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              selected: user.uid == selectedUid,
              onTap: () => onSelect(user),
              leading: Avatar(user: user, radius: 26),
              title: Text(user.name, style: const TextStyle(fontSize: 18)),
              subtitle: Text(user.email, style: const TextStyle(fontSize: 14)),
            );
          },
        );
      },
    );
  }
}
