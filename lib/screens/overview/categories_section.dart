import 'package:flutter/cupertino.dart';
import '../../../models/smart_category.dart';
import '../../../widgets/category_card.dart';
import 'overview_constants.dart';

typedef CategoryCallback = void Function(SmartCategory category);

class CategoriesSection extends StatelessWidget {
  final List<SmartCategory> categories;
  final CategoryCallback onTap;
  final CategoryCallback onLongPress;

  const CategoriesSection({
    super.key,
    required this.categories,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: categoriesColumnSpacingSize),
          child: Text(categoriesSectionTitle, style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        ),
        for (final category in categories)
          Padding(
            padding: const EdgeInsets.only(bottom: categoriesColumnSpacingSize),
            child: CategoryCard(
              category: category,
              onTap: () => onTap(category),
              onLongPress: () => onLongPress(category),
            ),
          ),
      ],
    );
  }
}