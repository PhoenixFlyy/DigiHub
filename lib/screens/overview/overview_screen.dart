import 'package:digi_hub/screens/overview/upcoming_section.dart';
import 'package:digi_hub/screens/settings_screen.dart';
import 'package:flutter/cupertino.dart';

import '../../models/smart_category.dart';
import '../../utils/debugTestValues.dart';
import '../../widgets/add_edit_sheet.dart';
import '../category_detail_screen.dart';
import 'add_new_button.dart';
import 'categories_section.dart';
import 'metrics_section.dart';
import 'overview_constants.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Überblick'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _navigateToSettings,
              child: const Icon(CupertinoIcons.gear),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: mainPaddingSide),
              child: Column(
                children: [
                  const SizedBox(height: mainColumnSpacingSize),
                  const MetricsSection(),
                  const SizedBox(height: mainColumnSpacingSize),
                  AddNewButton(onPressed: _showAddCategorySheet),
                  const SizedBox(height: mainColumnSpacingSize),
                  const UpcomingSection(),
                  const SizedBox(height: mainColumnSpacingSize),
                  CategoriesSection(categories: categories, onTap: _onCategoryTapped, onLongPress: _onCategoryLongPressed),
                  const SizedBox(height: mainColumnSpacingSize),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCategoryTapped(SmartCategory category) {
    Navigator.push(context, CupertinoPageRoute(builder: (_) => CategoryDetailScreen(category: category)));
  }

  void _onCategoryLongPressed(SmartCategory category) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text(categoriesDeleteTitle),
          content: const Text(categoriesDeleteContent),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text(categoriesDeleteCancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text(categoriesDeleteConfirm),
              onPressed: () {
                // TODO: Handle delete logic
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddCategorySheet() {
    showCupertinoModalPopup(context: context, builder: (_) => const AddCategorySheet());
  }

  void _navigateToSettings() {
    Navigator.push(context, CupertinoPageRoute(builder: (_) => const SettingsScreen()));
  }
}
