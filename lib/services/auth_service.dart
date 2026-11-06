import 'package:firebase_auth/firebase_auth.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/services/chat_repository.dart';

class AuthService {
  AuthService(this._auth, this._chats);

  final FirebaseAuth _auth;
  final ChatRepository _chats;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> signIn({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;

    await user.updateDisplayName(name.trim());
    await _chats.saveUser(
      ChatUser(uid: user.uid, name: name.trim(), email: email.trim()),
    );
  }

  Future<void> signOut() => _auth.signOut();

  /// Turns Firebase error codes into something a person can act on.
  static String messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'email-already-in-use':
        return 'An account with that email already exists.';
      case 'weak-password':
        return 'Use a password with at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Wrong email or password.';
      case 'network-request-failed':
        return 'No connection. Check your internet and try again.';
      default:
        return error.message ?? 'Something went wrong. Try again.';
    }
  }
}
