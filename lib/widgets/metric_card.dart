import 'package:flutter/cupertino.dart';
import '../utils/colors.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String iconName;

  const MetricCard({super.key, required this.title, required this.value, required this.iconName});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    // Replace Card with a styled Container
    return Container(
      decoration: BoxDecoration(
        color: theme.barBackgroundColor, // Use a theme-appropriate color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(getIconData(iconName), color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.tabLabelTextStyle),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.navTitleTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}