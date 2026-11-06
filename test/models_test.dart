import 'package:flutter_test/flutter_test.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/utils/format_time.dart';

void main() {
  group('ChatUser.initials', () {
    ChatUser user(String name, [String email = 'x@example.com']) =>
        ChatUser(uid: 'u', name: name, email: email);

    test('uses the first two names', () {
      expect(user('Abebe Kebede Tesfaye').initials, 'AK');
    });

    test('handles a single name and extra spaces', () {
      expect(user('  bisrat  ').initials, 'B');
    });

    test('falls back to the email when there is no name', () {
      expect(user('', 'zed@example.com').initials, 'Z');
      expect(user('', '').initials, '?');
    });
  });

  group('ChatUser map round trip', () {
    test('keeps name and email', () {
      const original = ChatUser(uid: 'u1', name: 'Sara', email: 's@e.com');
      final copy = ChatUser.fromMap('u1', original.toMap());

      expect(copy.name, 'Sara');
      expect(copy.email, 's@e.com');
    });
  });

  group('formatTime', () {
    test('formats morning, noon, afternoon and midnight', () {
      expect(formatTime(DateTime(2024, 1, 1, 9, 5)), '9:05 am');
      expect(formatTime(DateTime(2024, 1, 1, 12, 30)), '12:30 pm');
      expect(formatTime(DateTime(2024, 1, 1, 17, 0)), '5:00 pm');
      expect(formatTime(DateTime(2024, 1, 1, 0, 15)), '12:15 am');
    });
  });
}
