import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
  });

  factory Message.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    final sentAt = data['sentAt'];

    return Message(
      id: doc.id,
      senderId: (data['senderId'] as String?) ?? '',
      text: (data['text'] as String?) ?? '',
      // serverTimestamp() is null locally until the write reaches the server
      sentAt: sentAt is Timestamp ? sentAt.toDate() : DateTime.now(),
    );
  }
}
