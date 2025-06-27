import 'package:digi_hub/providers/theme_manager.dart';
import 'package:digi_hub/screens/overview/overview_screen.dart';
import 'package:digi_hub/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => ThemeManager(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        Brightness brightness;
        switch (themeManager.themeMode) {
          case ThemeMode.dark:
            brightness = Brightness.dark;
            break;
          case ThemeMode.light:
            brightness = Brightness.light;
            break;
          case ThemeMode.system:
            brightness = MediaQuery.of(context).platformBrightness;
            break;
        }

        return CupertinoApp(
          debugShowCheckedModeBanner: false,
          title: appTitle,
          theme: CupertinoThemeData(brightness: brightness),
          home: const OverviewScreen(),
        );
      },
    );
  }
}
