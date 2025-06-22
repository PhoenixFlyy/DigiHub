import 'package:digi_hub/providers/overview_view_model.dart';
import 'package:digi_hub/screens/overview_screen.dart';
import 'package:digi_hub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider makes the OverviewViewModel available to all
    // widgets below it in the tree. This is Flutter's equivalent to @StateObject.
    return ChangeNotifierProvider(
      create: (context) => OverviewViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          // Custom card theme to match the SwiftUI look
          cardTheme: CardThemeData(elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        ),
        home: const OverviewScreen(),
      ),
    );
  }
}
