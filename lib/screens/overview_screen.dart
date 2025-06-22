import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/smart_category.dart';
import '../providers/overview_view_model.dart';
import '../utils/formatters.dart';
import '../widgets/add_edit_sheet.dart';
import '../widgets/category_card.dart';
import '../widgets/metric_card.dart';
import 'category_detail_screen.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OverviewViewModel>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: const Text('Overview'),
        trailing: CupertinoButton(onPressed: () => _showAddFlow(context), child: const Icon(CupertinoIcons.add)),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            _buildMetricsSection(vm),
            const SizedBox(height: 24),
            _buildCategoriesSection(context, vm),
            if (vm.nextDueDocs.isNotEmpty) ...[const SizedBox(height: 24), _buildUpNextSection(context, vm)],
          ],
        ),
      ),
    );
  }

  void _showAddFlow(BuildContext context) {
    showCupertinoModalPopup(context: context, builder: (_) => AddEditCategorySheet());
  }

  void _onCategoryTapped(BuildContext context, SmartCategory category) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => CategoryDetailScreen(category: category)));
  }

  void _onCategoryLongPressed(BuildContext context, SmartCategory category) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Löschen?'),
          content: const Text('Willst du das Objekt wirklich löschen?'),
          actions: <Widget>[
            CupertinoDialogAction(child: const Text('Abbrechen'), onPressed: () => Navigator.of(dialogContext).pop()),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Löschen'),
              onPressed: () {
                context.read<OverviewViewModel>().deleteCategoryById(category.id);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricsSection(OverviewViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: MetricCard(title: "Abo monatlich", value: currencyFormat.format(vm.aboMonthlyTotal), iconName: "repeat"),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: MetricCard(
            title: "Ø Nicht-Abo",
            value: currencyFormat.format(vm.nonAboMonthlyAverage),
            iconName: "chart.bar",
          ),
        ),
      ],
    );
  }

  Widget _buildUpNextSection(BuildContext context, OverviewViewModel vm) {
    final theme = CupertinoTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text('Up next', style: theme.textTheme.navTitleTextStyle),
        ),
        Container(
          decoration: BoxDecoration(color: theme.barBackgroundColor, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: vm.nextDueDocs
                .take(3)
                .map(
                  (doc) => CupertinoListTile(
                    leading: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(color: CupertinoColors.systemGreen.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(CupertinoIcons.arrow_up, color: CupertinoColors.systemGreen, size: 20),
                    ),
                    title: Text(doc.title),
                    subtitle: Text('in ${daysBetween(DateTime.now(), doc.nextDueDate!)} days'),
                    trailing: Text(
                      currencyFormat.format(doc.cost ?? 0),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context, OverviewViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text('Subscriptions', style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        ),
        if (vm.categories.isEmpty)
          const Center(
            child: Padding(padding: EdgeInsets.all(32.0), child: Text("No categories yet. Add one!")),
          )
        else
          ...vm.categories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CategoryCard(
                category: cat,
                onTap: () => _onCategoryTapped(context, cat),
                onLongPress: () => _onCategoryLongPressed(context, cat),
              ),
            ),
          ),
      ],
    );
  }
}
