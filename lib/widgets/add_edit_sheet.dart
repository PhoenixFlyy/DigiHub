import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../models/main_category_type.dart';
import '../models/smart_category.dart';
import '../models/smart_document.dart';
import '../providers/overview_view_model.dart';
import '../utils/colors.dart';

class AddEditCategorySheet extends StatefulWidget {
  final SmartCategory? category; // If null, it's "add" mode. Otherwise "edit".
  const AddEditCategorySheet({super.key, this.category});

  @override
  State<AddEditCategorySheet> createState() => _AddEditCategorySheetState();
}

class _AddEditCategorySheetState extends State<AddEditCategorySheet> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  late TextEditingController _nameController;
  late TextEditingController _amountController;

  // ... add controllers for all other fields
  late TextEditingController _versicherungsnummerController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  MainCategoryType _selectedType = MainCategoryType.subscription;
  String _selectedFrequency = 'Monatlich';
  Color _selectedColor = Colors.orange;
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
    if (_formKey.currentState!.validate()) {
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
          attachments: [], // Attachment adding not implemented in this simplified sheet yet
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(_isEditMode ? 'Objekt bearbeiten' : 'Kategorie anlegen', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty) ? 'Name darf nicht leer sein' : null,
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Betrag (€)', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) =>
                  (value != null && double.tryParse(value.replaceAll(',', '.')) == null) ? 'Gültigen Betrag eingeben' : null,
            ),
            const SizedBox(height: 16),

            // Category Type Picker (only for add mode)
            if (!_isEditMode)
              DropdownButtonFormField<MainCategoryType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Kategorie', border: OutlineInputBorder()),
                items: MainCategoryType.values
                    .map((type) => DropdownMenuItem(value: type, child: Text(type.rawValue)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
            const SizedBox(height: 16),

            // Dynamic fields based on type
            if (_selectedType == MainCategoryType.insurance) ..._buildInsuranceFields(),

            // Color & Icon
            _buildColorPicker(context),
            const SizedBox(height: 16),
            _buildIconPicker(),

            const SizedBox(height: 24),
            ElevatedButton(onPressed: _submitForm, child: Text(_isEditMode ? 'Speichern' : 'Anlegen')),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInsuranceFields() {
    return [
      TextFormField(
        controller: _versicherungsnummerController,
        decoration: const InputDecoration(labelText: 'Versicherungsnummer', border: OutlineInputBorder()),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _phoneController,
        decoration: const InputDecoration(labelText: 'Telefonnummer', border: OutlineInputBorder()),
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(labelText: 'Email-Adresse', border: OutlineInputBorder()),
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 16),
    ];
  }

  Widget _buildColorPicker(BuildContext context) {
    return ListTile(
      title: const Text('Farbe'),
      trailing: CircleAvatar(backgroundColor: _selectedColor, radius: 15),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Farbe auswählen'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _selectedColor,
                onColorChanged: (color) => setState(() => _selectedColor = color),
              ),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
        );
      },
    );
  }

  Widget _buildIconPicker() {
    return DropdownButtonFormField<String>(
      value: _selectedIcon,
      decoration: const InputDecoration(labelText: 'Symbol', border: OutlineInputBorder()),
      items: availableIconNames
          .map(
            (name) => DropdownMenuItem(
              value: name,
              child: Row(children: [Icon(getIconData(name)), const SizedBox(width: 8), Text(name)]),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedIcon = value!),
    );
  }
}
