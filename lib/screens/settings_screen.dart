import 'package:digi_hub/providers/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<ThemeManager>();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Einstellungen')),
      child: ListView(
        children: [
          CupertinoFormSection.insetGrouped(
            header: const Text('Darstellung'),
            children: [
              CupertinoListTile(
                title: const Text('Dark Mode'),
                trailing: CupertinoSwitch(
                  value: themeManager.themeMode == ThemeMode.dark,
                  onChanged: (bool value) {
                    final newMode = value ? ThemeMode.dark : ThemeMode.light;
                    context.read<ThemeManager>().setThemeMode(newMode);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
