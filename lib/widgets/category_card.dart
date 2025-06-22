import 'package:flutter/cupertino.dart';
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
    final theme = CupertinoTheme.of(context);

    // Use GestureDetector to handle both tap and long press
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      // A container provides the background color and mimics the card look
      child: Container(
        decoration: BoxDecoration(
          color: theme.barBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CupertinoListTile(
          padding: const EdgeInsets.all(12),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(getIconData(category.iconName), color: color, size: 22),
          ),
          title: Text(category.name, style: theme.textTheme.textStyle),
          subtitle: Row(
            children: [
              Text(
                '${category.documents.length} Dokument(e)',
                style: theme.textTheme.tabLabelTextStyle,
              ),
              if (totalAttachments > 0) ...[
                const SizedBox(width: 8),
                Icon(CupertinoIcons.paperclip, size: 14, color: theme.primaryColor),
                const SizedBox(width: 2),
                Text(
                  '$totalAttachments',
                  style: theme.textTheme.tabLabelTextStyle.copyWith(color: theme.primaryColor),
                ),
              ],
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormat.format(category.totalCost),
                style: theme.textTheme.textStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Monthly', // This could be dynamic
                style: theme.textTheme.tabLabelTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}