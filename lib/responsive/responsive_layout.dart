import 'package:flutter/material.dart';
import 'package:flychat/screens/mobile_screen_layout.dart';
import 'package:flychat/screens/web_screen_layout.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget webLayout;
  const ResponsiveLayout(
      {Key? key, required this.mobileLayout, required this.webLayout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 900) {
        return const WebScreenLayout();
      } else {
        return const MobileScreenLayout();
      }
    });
  }
}
