import 'package:flutter/cupertino.dart';

import '../../../widgets/metrics_main_card.dart';
import 'overview_constants.dart';

class MetricsSection extends StatelessWidget {
  const MetricsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: MetricsMainCard(title: monthlyAbo, value: "104,98€", icon: CupertinoIcons.repeat),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: MetricsMainCard(title: averageAbo, value: "122,99€", icon: CupertinoIcons.chart_bar),
        ),
      ],
    );
  }
}
