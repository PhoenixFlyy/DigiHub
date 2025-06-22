import 'package:flutter/cupertino.dart';
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

    // A custom theme to make nav bar icons and text white against the custom color.
    final headerTheme = CupertinoTheme.of(context).copyWith(
      primaryColor: CupertinoColors.white,
      scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      textTheme: CupertinoTheme.of(context).textTheme.copyWith(
        primaryColor: CupertinoColors.white,
      ),
    );

    return CupertinoPageScaffold(
      // We wrap the entire page in a CupertinoTheme to style the navigation bar
      child: CupertinoTheme(
        data: headerTheme,
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              backgroundColor: headerColor.withOpacity(0.8),
              largeTitle: Text(category.name),
              // Use stretch to allow the header to overscroll, common in iOS
              stretch: true,
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.pencil),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (_) => AddEditCategorySheet(category: category), // "edit" mode
                  );
                },
              ),
            ),

            // We build the body content as a list of slivers
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Header content (Icon and renewal date)
                  _buildHeaderContent(context, headerColor),

                  // Info columns (replaces the old Card)
                  _buildInfoColumns(context),
                  const SizedBox(height: 16),

                  // Contact Block
                  if (doc.extractedFields["Telefon"] != null && doc.extractedFields["Email"] != null)
                    _KontaktBlock(
                      phone: doc.extractedFields["Telefon"]!,
                      email: doc.extractedFields["Email"]!,
                    ),

                  // Details List
                  _buildDetailsList(context),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderContent(BuildContext context, Color headerColor) {
    final doc = category.documents.first;
    return Container(
      color: headerColor,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: CupertinoColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(getIconData(category.iconName), size: 40, color: headerColor),
          ),
          const SizedBox(height: 16),
          if (doc.nextDueDate != null)
            Text(
              'Renews on ${shortMonthDayFormat.format(doc.nextDueDate!)}',
              style: const TextStyle(color: CupertinoColors.white, fontSize: 16),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoColumns(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      // Use transform to pull the card up over the header background
      transform: Matrix4.translationValues(0.0, -25.0, 0.0),
      decoration: BoxDecoration(
          color: theme.barBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ]
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _InfoColumn(title: "Monthly", value: "Plan"),
            Container(width: 1, color: CupertinoColors.separator),
            _InfoColumn(title: currencyFormat.format(category.totalCost), value: "Monthly"),
            Container(width: 1, color: CupertinoColors.separator),
            _InfoColumn(title: "Active", value: "Status"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsList(BuildContext context) {
    final doc = category.documents.first;
    final exclude = ["Betrag", "Frequenz", "Telefon", "Email"];

    return CupertinoListSection.insetGrouped(
      header: const Text('DETAILS'),
      children: [
        _DetailRow(
          icon: CupertinoIcons.calendar,
          label: 'Next bill',
          value: doc.nextDueDate != null ? 'in ${daysBetween(DateTime.now(), doc.nextDueDate!)} days' : '—',
        ),
        _DetailRow(icon: CupertinoIcons.tag, label: 'Category', value: category.mainType.rawValue),
        _DetailRow(icon: CupertinoIcons.bell, label: 'Renewal reminder', value: "None"),
        ...doc.extractedFields.entries
            .where((entry) => !exclude.contains(entry.key) && entry.value.isNotEmpty)
            .map((entry) => _DetailRow(icon: CupertinoIcons.info, label: entry.key, value: entry.value)),
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
    final theme = CupertinoTheme.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Text(title, style: theme.textTheme.navTitleTextStyle.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.tabLabelTextStyle),
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
    return CupertinoListTile(
      leading: Icon(icon, color: CupertinoTheme.of(context).primaryColor),
      title: Text(label),
      trailing: Text(value, style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle),
    );
  }
}

class _KontaktBlock extends StatelessWidget {
  final String phone;
  final String email;

  const _KontaktBlock({required this.phone, required this.email});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: const Text('KONTAKT'),
      children: [
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.phone, color: CupertinoColors.activeGreen),
          title: Text(phone),
          onTap: () => launchUrl(Uri.parse('tel:$phone')),
        ),
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.mail, color: CupertinoColors.activeBlue),
          title: Text(email),
          onTap: () => launchUrl(Uri.parse('mailto:$email')),
        ),
      ],
    );
  }
}