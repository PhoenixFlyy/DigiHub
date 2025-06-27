import 'package:flutter/cupertino.dart';

import 'overview_constants.dart';

class UpcomingSection extends StatelessWidget {
  const UpcomingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(upcomingSectionTitle, style: theme.textTheme.navTitleTextStyle),
        ),
        Container(
          decoration: BoxDecoration(color: theme.barBackgroundColor, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              CupertinoListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(color: CupertinoColors.systemGreen.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(CupertinoIcons.arrow_up, color: CupertinoColors.systemGreen, size: 20),
                ),
                title: const Text("TODO Title"),
                subtitle: const Text("TODO IN DAYS"),
                trailing: const Text("monthly todo", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
