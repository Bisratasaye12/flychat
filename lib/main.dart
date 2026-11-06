import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flychat/Features/Landing/Screens/landing_screen.dart';
import 'package:flychat/colors.dart';
import 'package:flychat/firebase_options.dart';
import 'package:flychat/responsive/responsive_layout.dart';
import 'package:flychat/screens/mobile_screen_layout.dart';
import 'package:flychat/screens/web_screen_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const LandingScreen(),
      // home: const ResponsiveLayout(
      //   mobileLayout: MobileScreenLayout(),
      //   webLayout: WebScreenLayout(),
      // ),
    );
  }
}
