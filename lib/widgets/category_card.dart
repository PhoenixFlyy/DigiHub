import 'package:flutter/material.dart';

import '../models/smart_category.dart';
import '../utils/colors.dart';
import '../utils/formatters.dart';

class CategoryCard extends StatelessWidget {
  final SmartCategory category;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CategoryCard({super.key, required this.category, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final color = HexColor.fromHex(category.colorHex);
    final totalAttachments = category.documents.fold(0, (sum, doc) => sum + doc.attachments.length);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(getIconData(category.iconName), color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('${category.documents.length} Dokument(e)', style: Theme.of(context).textTheme.bodySmall),
                        if (totalAttachments > 0) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.attach_file, size: 14, color: Theme.of(context).colorScheme.primary),
                          Text(
                            '$totalAttachments',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(currencyFormat.format(category.totalCost), style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    'Monthly', // This could be dynamic based on document intervals
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
