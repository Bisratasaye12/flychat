import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flychat/models/message.dart';
import 'package:flychat/widgets/chat_input.dart';
import 'package:flychat/widgets/chat_list.dart';
import 'package:flychat/widgets/my_message_card.dart';
import 'package:flychat/widgets/sender_message_card.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('ChatInput sends trimmed text and clears the field',
      (tester) async {
    final sent = <String>[];
    await tester.pumpWidget(wrap(ChatInput(onSend: sent.add)));

    await tester.enterText(find.byType(TextField), '  hello  ');
    await tester.tap(find.byTooltip('Send'));
    await tester.pump();

    expect(sent, ['hello']);
    expect(find.text('hello'), findsNothing);
  });

  testWidgets('ChatInput ignores an empty message', (tester) async {
    final sent = <String>[];
    await tester.pumpWidget(wrap(ChatInput(onSend: sent.add)));

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.byTooltip('Send'));

    expect(sent, isEmpty);
  });

  testWidgets('ChatList puts my messages and theirs in different bubbles',
      (tester) async {
    final messages = [
      Message(id: '1', senderId: 'me', text: 'mine', sentAt: DateTime(2024)),
      Message(id: '2', senderId: 'them', text: 'theirs', sentAt: DateTime(2024)),
    ];

    await tester.pumpWidget(
        wrap(ChatList(messages: Stream.value(messages), myUid: 'me')));
    await tester.pump();

    expect(
      find.descendant(
          of: find.byType(MyMessageCard), matching: find.text('mine')),
      findsOneWidget,
    );
    expect(
      find.descendant(
          of: find.byType(SenderMessageCard), matching: find.text('theirs')),
      findsOneWidget,
    );
  });

  testWidgets('ChatList shows an empty state', (tester) async {
    await tester.pumpWidget(wrap(
        ChatList(messages: Stream.value(const <Message>[]), myUid: 'me')));
    await tester.pump();

    expect(find.text('No messages yet. Say hi!'), findsOneWidget);
  });
}
