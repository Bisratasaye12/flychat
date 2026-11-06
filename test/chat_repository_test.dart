import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/services/chat_repository.dart';

void main() {
  late FakeFirebaseFirestore db;
  late ChatRepository chats;

  const alice = ChatUser(uid: 'alice', name: 'Alice', email: 'a@example.com');
  const bob = ChatUser(uid: 'bob', name: 'Bob', email: 'b@example.com');

  setUp(() {
    db = FakeFirebaseFirestore();
    chats = ChatRepository(db);
  });

  test('chatIdFor is the same whichever user starts the chat', () {
    expect(ChatRepository.chatIdFor('bob', 'alice'), 'alice_bob');
    expect(ChatRepository.chatIdFor('alice', 'bob'), 'alice_bob');
  });

  test('contacts lists everyone except me, sorted by name', () async {
    await chats.saveUser(bob);
    await chats.saveUser(alice);
    await chats.saveUser(
        const ChatUser(uid: 'cara', name: 'Cara', email: 'c@example.com'));

    final contacts = await chats.contacts('alice').first;

    expect(contacts.map((u) => u.name), ['Bob', 'Cara']);
  });

  test('sendMessage stores a trimmed message both users can read', () async {
    await chats.sendMessage(from: 'alice', to: 'bob', text: '  hi bob  ');

    final forAlice = await chats.messages('alice', 'bob').first;
    final forBob = await chats.messages('bob', 'alice').first;

    expect(forAlice.single.text, 'hi bob');
    expect(forAlice.single.senderId, 'alice');
    expect(forBob.single.id, forAlice.single.id);
  });

  test('sendMessage updates the chat summary', () async {
    await chats.sendMessage(from: 'alice', to: 'bob', text: 'first');
    await chats.sendMessage(from: 'bob', to: 'alice', text: 'second');

    final chat = await db.collection('chats').doc('alice_bob').get();

    expect(chat.data()!['lastMessage'], 'second');
    expect(chat.data()!['members'], ['alice', 'bob']);
  });

  test('sendMessage ignores blank text', () async {
    await chats.sendMessage(from: 'alice', to: 'bob', text: '   ');

    expect(await chats.messages('alice', 'bob').first, isEmpty);
  });

  test('messages come back in the order they were sent', () async {
    for (final text in ['one', 'two', 'three']) {
      await chats.sendMessage(from: 'alice', to: 'bob', text: text);
    }

    final messages = await chats.messages('bob', 'alice').first;

    expect(messages.map((m) => m.text), ['one', 'two', 'three']);
  });
}
