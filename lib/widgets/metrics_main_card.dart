import 'package:digi_hub/utils/ui_constants.dart';
import 'package:flutter/cupertino.dart';

class MetricsMainCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const MetricsMainCard({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: CupertinoColors.activeGreen,
        shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(roundedSuperellipseBorderRadius)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, color: CupertinoTheme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(title, style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle),
              ],
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                value,
                style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
