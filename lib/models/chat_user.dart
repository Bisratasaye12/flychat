class ChatUser {
  final String uid;
  final String name;
  final String email;

  const ChatUser({required this.uid, required this.name, required this.email});

  factory ChatUser.fromMap(String uid, Map<String, dynamic> data) {
    return ChatUser(
      uid: uid,
      name: (data['name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() => {'name': name, 'email': email};

  /// Up to two letters for the avatar, e.g. "Abebe Kebede" -> "AK".
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return email.isEmpty ? '?' : email[0].toUpperCase();
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
