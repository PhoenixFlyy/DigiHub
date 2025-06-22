import 'package:digi_hub/providers/overview_view_model.dart';
import 'package:digi_hub/screens/overview_screen.dart';
import 'package:digi_hub/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OverviewViewModel(),
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: CupertinoThemeData(
          brightness: Brightness.dark
        ),
        home: const OverviewScreen(),
      ),
    );
  }
}
