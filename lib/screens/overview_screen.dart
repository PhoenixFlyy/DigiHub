import 'package:flutter/material.dart';
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
    // Listen to changes in the ViewModel
    final vm = context.watch<OverviewViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        // In a real app, you might add settings or other actions here
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Metrics Section
          _buildMetricsSection(vm),
          const SizedBox(height: 24),

          // Add Button
          _buildAddButton(context),
          const SizedBox(height: 24),

          // Up Next Section
          if (vm.nextDueDocs.isNotEmpty) ...[_buildUpNextSection(vm), const SizedBox(height: 24)],

          // Subscriptions/Categories Section
          _buildCategoriesSection(context, vm),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFlow(context),
        tooltip: 'Add new',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFlow(BuildContext context) {
    // This is a simplified flow. The SwiftUI version has a picker first.
    // We'll go straight to the add sheet for a specific type for now.
    // A more complex implementation would use showModalBottomSheet for the picker first.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddEditCategorySheet(), // Defaults to "add" mode
      ),
    );
  }

  void _onCategoryTapped(BuildContext context, SmartCategory category) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailScreen(category: category)));
  }

  void _onCategoryLongPressed(BuildContext context, SmartCategory category) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Löschen?'),
          content: const Text('Willst du das Objekt wirklich löschen?'),
          actions: <Widget>[
            TextButton(child: const Text('Abbrechen'), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
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

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.add),
      label: const Text('Add new'),
      onPressed: () => _showAddFlow(context),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }

  Widget _buildUpNextSection(OverviewViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO: Text('Up next', style: Theme.of(context).textTheme.titleLarge),
        Text('Up next'),
        const SizedBox(height: 10),
        ...vm.nextDueDocs
            .take(3)
            .map(
              (doc) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.withOpacity(0.2),
                    child: const Icon(Icons.arrow_upward, color: Colors.green, size: 20),
                  ),
                  title: Text(doc.title),
                  subtitle: Text('in ${daysBetween(DateTime.now(), doc.nextDueDate!)} days'),
                  trailing: Text(currencyFormat.format(doc.cost ?? 0), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context, OverviewViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subscriptions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        if (vm.categories.isEmpty)
          const Center(child: Text("No categories yet. Add one!"))
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
