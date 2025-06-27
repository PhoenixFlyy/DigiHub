import 'package:digi_hub/screens/overview/overview_screen.dart';
import 'package:digi_hub/utils/constants.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      home: const OverviewScreen(),
    );
  }
}
