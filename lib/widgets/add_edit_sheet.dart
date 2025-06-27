import 'package:digi_hub/models/main_category_type.dart';
import 'package:digi_hub/models/smart_category.dart';
import 'package:digi_hub/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../models/smart_document.dart';

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  MainCategoryType _selectedType = MainCategoryType.subscription;
  Color _selectedColor = CupertinoColors.systemBlue;
  IconData _selectedIcon = CupertinoIcons.folder;
  final List<IconData> _availableIcons = [
    CupertinoIcons.folder,
    CupertinoIcons.tv,
    CupertinoIcons.money_dollar_circle,
    CupertinoIcons.house_fill,
    CupertinoIcons.car_fill,
    CupertinoIcons.heart_fill,
    CupertinoIcons.book_fill,
    CupertinoIcons.gift_fill,
    CupertinoIcons.shopping_cart,
    CupertinoIcons.airplane,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_nameController.text.isEmpty) {
      debugPrint("Validation failed: Name is required.");
      return;
    }
    final newDoc = SmartDocument(
      title: _nameController.text,
      cost: double.tryParse(_amountController.text.replaceAll(',', '.')),
      extractedFields: {},
    );
    final newCategory = SmartCategory(
      name: _nameController.text,
      mainType: _selectedType,
      icon: _selectedIcon,
      colorHex: _selectedColor.toHex(),
      documents: [newDoc],
    );
    Navigator.of(context).pop(newCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavBar(),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  CupertinoFormSection.insetGrouped(
                    header: const Text('Details'),
                    children: [
                      _buildTextFieldRow('Name', _nameController, 'z.B. Netflix Abo'),
                      _buildTextFieldRow(
                        'Betrag (€)',
                        _amountController,
                        '12,99',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                      _buildPickerRow(
                        label: 'Kategorie',
                        value: _selectedType.rawValue,
                        onTap: () => _showPicker<MainCategoryType>(
                          items: MainCategoryType.values,
                          initialItem: _selectedType,
                          itemBuilder: (type) => Text(type.rawValue),
                          onSelectedItemChanged: (newType) => setState(() => _selectedType = newType),
                        ),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    header: const Text('Darstellung'),
                    children: [
                      _buildPickerRow(
                        label: 'Farbe',
                        valueWidget: Container(width: 28, height: 28, color: _selectedColor),
                        onTap: _showColorPicker,
                      ),
                      _buildPickerRow(
                        label: 'Symbol',
                        valueWidget: Icon(_selectedIcon),
                        onTap: () => _showPicker<IconData>(
                          items: _availableIcons,
                          initialItem: _selectedIcon,
                          itemBuilder: (icon) => Icon(icon),
                          onSelectedItemChanged: (newIcon) => setState(() => _selectedIcon = newIcon),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: CupertinoColors.separator.resolveFrom(context))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Abbrechen'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Text('Neue Kategorie', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          CupertinoButton(padding: EdgeInsets.zero, onPressed: _submitForm, child: const Text('Anlegen')),
        ],
      ),
    );
  }

  Widget _buildTextFieldRow(
    String label,
    TextEditingController controller,
    String placeholder, {
    TextInputType? keyboardType,
  }) {
    return CupertinoFormRow(
      prefix: Text(label),
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        textAlign: TextAlign.end,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildPickerRow({required String label, String? value, Widget? valueWidget, required VoidCallback onTap}) {
    return CupertinoListTile(
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (valueWidget != null) valueWidget else Text(value ?? ''),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.chevron_forward, size: 20, color: CupertinoColors.tertiaryLabel),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showColorPicker() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Farbe auswählen'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) => setState(() => _selectedColor = color),
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
          ),
        ),
        actions: [
          CupertinoDialogAction(isDefaultAction: true, child: const Text('OK'), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  void _showPicker<T>({
    required List<T> items,
    required T initialItem,
    required Widget Function(T) itemBuilder,
    required ValueChanged<T> onSelectedItemChanged,
  }) {
    final initialIndex = items.indexOf(initialItem);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: initialIndex),
            itemExtent: 32.0,
            onSelectedItemChanged: (index) => onSelectedItemChanged(items[index]),
            children: items.map((item) => Center(child: itemBuilder(item))).toList(),
          ),
        ),
      ),
    );
  }
}
