import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flychat/colors.dart';
import 'package:flychat/firebase_options.dart';
import 'package:flychat/models/chat_user.dart';
import 'package:flychat/responsive/responsive_layout.dart';
import 'package:flychat/screens/auth_screen.dart';
import 'package:flychat/screens/mobile_screen_layout.dart';
import 'package:flychat/screens/web_screen_layout.dart';
import 'package:flychat/services/auth_service.dart';
import 'package:flychat/services/chat_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final chats = ChatRepository(FirebaseFirestore.instance);
  runApp(MyApp(chats: chats, auth: AuthService(FirebaseAuth.instance, chats)));
}

class MyApp extends StatelessWidget {
  final ChatRepository chats;
  final AuthService auth;

  const MyApp({super.key, required this.chats, required this.auth});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flychat',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = snapshot.data;
          if (user == null) return AuthScreen(auth: auth);

          final me = ChatUser(
            uid: user.uid,
            name: user.displayName ?? user.email ?? 'Me',
            email: user.email ?? '',
          );
          return ResponsiveLayout(
            mobileLayout:
                MobileScreenLayout(me: me, chats: chats, onSignOut: auth.signOut),
            webLayout:
                WebScreenLayout(me: me, chats: chats, onSignOut: auth.signOut),
          );
        },
      ),
    );
  }
}
