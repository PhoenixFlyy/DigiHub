import 'package:digi_hub/utils/ui_constants.dart';
import 'package:flutter/cupertino.dart';

import 'overview_constants.dart';

class MetricsSection extends StatelessWidget {
  const MetricsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _MetricsMainCard(title: monthlyAbo, value: "104,98€", icon: CupertinoIcons.repeat),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _MetricsMainCard(title: averageAbo, value: "122,99€", icon: CupertinoIcons.chart_bar),
        ),
      ],
    );
  }
}

class _MetricsMainCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricsMainCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: CupertinoTheme.of(context).barBackgroundColor,
        shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(roundedSuperellipseBorderRadius)),
        shadows: [
          BoxShadow(
            color: CupertinoColors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
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
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
