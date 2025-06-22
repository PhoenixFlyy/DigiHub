import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../models/main_category_type.dart';
import '../models/smart_category.dart';
import '../models/smart_document.dart';
import '../providers/overview_view_model.dart';
import '../utils/colors.dart';

class AddEditCategorySheet extends StatefulWidget {
  final SmartCategory? category;
  const AddEditCategorySheet({super.key, this.category});

  @override
  State<AddEditCategorySheet> createState() => _AddEditCategorySheetState();
}

class _AddEditCategorySheetState extends State<AddEditCategorySheet> {
  // Form validation is now manual, so the key is less critical but can be kept for other purposes.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _versicherungsnummerController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  MainCategoryType _selectedType = MainCategoryType.subscription;
  String _selectedFrequency = 'Monatlich';
  Color _selectedColor = CupertinoColors.systemOrange;
  String _selectedIcon = 'folder';

  bool get _isEditMode => widget.category != null;

  @override
  void initState() {
    super.initState();
    final doc = widget.category?.documents.first;

    _nameController = TextEditingController(text: doc?.title ?? '');
    _amountController = TextEditingController(text: doc?.extractedFields['Betrag'] ?? '');
    _versicherungsnummerController = TextEditingController(text: doc?.extractedFields['Versicherungsnummer'] ?? '');
    _phoneController = TextEditingController(text: doc?.extractedFields['Telefon'] ?? '');
    _emailController = TextEditingController(text: doc?.extractedFields['Email'] ?? '');

    if (_isEditMode) {
      _selectedType = widget.category!.mainType;
      _selectedFrequency = doc?.interval ?? 'Monatlich';
      _selectedColor = HexColor.fromHex(widget.category!.colorHex);
      _selectedIcon = widget.category!.iconName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _versicherungsnummerController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Manual validation
    if (_nameController.text.isEmpty) {
      // In a real app, you'd show an alert here.
      debugPrint("Validation failed: Name is empty");
      return;
    }

    final vm = context.read<OverviewViewModel>();
    final amount = _amountController.text.replaceAll(',', '.');

    final extraFields = {
      "Betrag": _amountController.text,
      "Frequenz": _selectedFrequency,
      "Versicherungsnummer": _versicherungsnummerController.text,
      "Telefon": _phoneController.text,
      "Email": _emailController.text,
    };

    if (_isEditMode) {
      final updatedDoc = SmartDocument(
        id: widget.category!.documents.first.id,
        title: _nameController.text,
        cost: double.tryParse(amount),
        interval: _selectedFrequency,
        extractedFields: extraFields,
        attachments: widget.category!.documents.first.attachments,
      );
      vm.updateCategory(
        originalCategory: widget.category!,
        updatedDoc: updatedDoc,
        icon: _selectedIcon,
        color: '#${_selectedColor.value.toRadixString(16).substring(2)}',
      );
    } else {
      vm.addCategory(
        mainType: _selectedType,
        name: _nameController.text,
        iconName: _selectedIcon,
        colorHex: '#${_selectedColor.value.toRadixString(16).substring(2)}',
        extraFields: extraFields,
        attachments: [],
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with CupertinoPageScaffold for proper background and layout
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_isEditMode ? 'Objekt bearbeiten' : 'Kategorie anlegen'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Abbrechen'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(_isEditMode ? 'Speichern' : 'Anlegen', style: const TextStyle(fontWeight: FontWeight.bold)),
          onPressed: _submitForm,
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              CupertinoFormSection.insetGrouped(
                header: const Text('Allgemein'),
                children: [
                  CupertinoFormRow(
                    prefix: const Text('Name'),
                    child: CupertinoTextField(
                      controller: _nameController,
                      placeholder: 'z.B. Netflix Abo',
                      textAlign: TextAlign.end,
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: const Text('Betrag (€)'),
                    child: CupertinoTextField(
                      controller: _amountController,
                      placeholder: '12,99',
                      textAlign: TextAlign.end,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  if (!_isEditMode)
                    _buildPickerRow<MainCategoryType>(
                      label: 'Kategorie',
                      value: _selectedType,
                      items: MainCategoryType.values,
                      onChanged: (newValue) => setState(() => _selectedType = newValue),
                      itemBuilder: (type) => Text(type.rawValue),
                    ),
                ],
              ),
              if (_selectedType == MainCategoryType.insurance)
                CupertinoFormSection.insetGrouped(
                  header: const Text('Versicherungsdetails'),
                  children: _buildInsuranceFields(),
                ),
              CupertinoFormSection.insetGrouped(
                header: const Text('Darstellung'),
                children: [
                  _buildColorPicker(context),
                  _buildIconPicker(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInsuranceFields() {
    return [
      CupertinoFormRow(
        prefix: const Text('Vers.-Nr.'),
        child: CupertinoTextField(
            controller: _versicherungsnummerController, placeholder: 'Optional', textAlign: TextAlign.end),
      ),
      CupertinoFormRow(
        prefix: const Text('Telefon'),
        child: CupertinoTextField(
            controller: _phoneController,
            placeholder: 'Optional',
            textAlign: TextAlign.end,
            keyboardType: TextInputType.phone),
      ),
      CupertinoFormRow(
        prefix: const Text('Email'),
        child: CupertinoTextField(
            controller: _emailController,
            placeholder: 'Optional',
            textAlign: TextAlign.end,
            keyboardType: TextInputType.emailAddress),
      ),
    ];
  }

  Widget _buildColorPicker(BuildContext context) {
    return CupertinoListTile(
      title: const Text('Farbe'),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: _selectedColor,
          shape: BoxShape.circle,
          border: Border.all(color: CupertinoColors.separator, width: 0.5),
        ),
      ),
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Farbe auswählen'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _selectedColor,
                onColorChanged: (color) => setState(() => _selectedColor = color),
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconPicker() {
    return _buildPickerRow<String>(
      label: 'Symbol',
      value: _selectedIcon,
      items: availableIconNames,
      onChanged: (newValue) => setState(() => _selectedIcon = newValue),
      itemBuilder: (name) => Row(
        children: [
          Icon(getIconData(name), color: CupertinoColors.label),
          const SizedBox(width: 8),
          Text(name),
        ],
      ),
    );
  }

  // Helper for creating picker rows
  Widget _buildPickerRow<T>({
    required String label,
    required T value,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    required ValueChanged<T> onChanged,
  }) {
    return CupertinoListTile(
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          itemBuilder(value),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.chevron_up_chevron_down),
        ],
      ),
      onTap: () => _showPicker(context, items: items, initialItem: value, itemBuilder: itemBuilder, onSelectedItemChanged: (index) => onChanged(items[index])),
    );
  }

  // Helper to show a CupertinoPicker
  void _showPicker<T>(
      BuildContext context, {
        required List<T> items,
        required T initialItem,
        required Widget Function(T) itemBuilder,
        required ValueChanged<int> onSelectedItemChanged,
      }) {
    final initialIndex = items.indexOf(initialItem);
    final controller = FixedExtentScrollController(initialItem: initialIndex > -1 ? initialIndex : 0);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            scrollController: controller,
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32.0,
            onSelectedItemChanged: onSelectedItemChanged,
            children: items.map((T item) => Center(child: itemBuilder(item))).toList(),
          ),
        ),
      ),
    );
  }
}