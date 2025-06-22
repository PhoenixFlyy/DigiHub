import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/smart_category.dart';
import '../utils/colors.dart';
import '../utils/formatters.dart';
import '../widgets/add_edit_sheet.dart';

class CategoryDetailScreen extends StatelessWidget {
  final SmartCategory category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final Color headerColor = HexColor.fromHex(category.colorHex);
    final doc = category.documents.first; // Assuming one document per category for now

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            pinned: true,
            backgroundColor: headerColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddEditCategorySheet(category: category), // "edit" mode
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(category.name, style: const TextStyle(color: Colors.white)),
              background: Container(
                color: headerColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(getIconData(category.iconName), size: 40, color: headerColor),
                    ),
                    const SizedBox(height: 10),
                    if (doc.nextDueDate != null)
                      Text(
                        'Renews on ${shortMonthDayFormat.format(doc.nextDueDate!)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Body content as a sliver
          SliverToBoxAdapter(
            child: Column(
              children: [
                Transform.translate(offset: const Offset(0, -20), child: _buildInfoColumns(context)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: _buildDetailsList(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumns(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 4,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _InfoColumn(title: "Monthly", value: "Plan"),
            const VerticalDivider(width: 1),
            _InfoColumn(title: currencyFormat.format(category.totalCost), value: "Monthly"),
            const VerticalDivider(width: 1),
            _InfoColumn(title: "Active", value: "Status"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsList(BuildContext context) {
    final doc = category.documents.first;
    final phone = doc.extractedFields["Telefon"];
    final email = doc.extractedFields["Email"];
    final exclude = ["Betrag", "Frequenz", "Telefon", "Email"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (phone != null && email != null) _KontaktBlock(phone: phone, email: email),

        const SizedBox(height: 8),

        _DetailRow(
          icon: Icons.calendar_today,
          label: 'Next bill',
          value: doc.nextDueDate != null ? 'in ${daysBetween(DateTime.now(), doc.nextDueDate!)} days' : '—',
        ),
        _DetailRow(icon: Icons.category_outlined, label: 'Category', value: category.mainType.rawValue),
        _DetailRow(icon: Icons.notifications_none, label: 'Renewal reminder', value: "None"),

        // Dynamic Fields
        ...doc.extractedFields.entries
            .where((entry) => !exclude.contains(entry.key) && entry.value.isNotEmpty)
            .map((entry) => _DetailRow(icon: Icons.info_outline, label: entry.key, value: entry.value)),

        const SizedBox(height: 16),
      ],
    );
  }
}

// Sub-widgets for the detail screen for better organization

class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const _InfoColumn({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        title: Text(label),
        trailing: Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}

class _KontaktBlock extends StatelessWidget {
  final String phone;
  final String email;

  const _KontaktBlock({required this.phone, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kontakt', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(phone),
              onTap: () => launchUrl(Uri.parse('tel:$phone')),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email),
              onTap: () => launchUrl(Uri.parse('mailto:$email')),
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
