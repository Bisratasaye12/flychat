import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/models/message.dart';

/// Firestore layout:
///   users/{uid}                       name, email
///   chats/{chatId}                    members, lastMessage, updatedAt
///   chats/{chatId}/messages/{id}      senderId, text, sentAt
class ChatRepository {
  ChatRepository(this._db);

  final FirebaseFirestore _db;

  /// Both people in a one-to-one chat get the same id, whoever starts it.
  static String chatIdFor(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  DocumentReference<Map<String, dynamic>> _chat(String a, String b) =>
      _db.collection('chats').doc(chatIdFor(a, b));

  Future<void> saveUser(ChatUser user) {
    return _users.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  Stream<List<ChatUser>> contacts(String myUid) {
    return _users.orderBy('name').snapshots().map((snapshot) => snapshot.docs
        .where((doc) => doc.id != myUid)
        .map((doc) => ChatUser.fromMap(doc.id, doc.data()))
        .toList());
  }

  Stream<List<Message>> messages(String myUid, String otherUid) {
    return _chat(myUid, otherUid)
        .collection('messages')
        .orderBy('sentAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Message.fromDoc).toList());
  }

  Future<void> sendMessage({
    required String from,
    required String to,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final chat = _chat(from, to);
    final batch = _db.batch()
      ..set(
        chat,
        {
          'members': [from, to]..sort(),
          'lastMessage': trimmed,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      )
      ..set(chat.collection('messages').doc(), {
        'senderId': from,
        'text': trimmed,
        'sentAt': FieldValue.serverTimestamp(),
      });

    await batch.commit();
  }
}
