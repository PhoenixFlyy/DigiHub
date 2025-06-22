import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/document_attachment.dart';
import '../models/main_category_type.dart';
import '../models/smart_category.dart';
import '../models/smart_document.dart';

class OverviewViewModel extends ChangeNotifier {
  List<SmartCategory> _categories = [];

  List<SmartCategory> get categories => _categories;

  static const _storageKey = "categories";

  OverviewViewModel() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? categoriesJson = prefs.getString(_storageKey);

    if (categoriesJson != null) {
      final List<dynamic> decodedJson = jsonDecode(categoriesJson);
      _categories = decodedJson.map((json) => SmartCategory.fromJson(json)).toList();
    } else {
      _categories = [
        SmartCategory(
          mainType: MainCategoryType.subscription,
          name: "iCloud",
          iconName: "cloud",
          colorHex: "#2986E7",
          documents: [
            SmartDocument(
              title: "iCloud",
              cost: 2.99,
              nextDueDate: DateTime.now().add(const Duration(days: 20)),
              interval: "Monatlich",
              extractedFields: {},
            ),
          ],
        ),
        SmartCategory(
          mainType: MainCategoryType.insurance,
          name: "Meine Versicherung",
          iconName: "shield",
          colorHex: "#4A90E2",
          documents: [
            SmartDocument(
              title: "Police 2024",
              cost: 15.99,
              nextDueDate: DateTime.now().add(const Duration(days: 60)),
              interval: "Jährlich",
              extractedFields: {"Versicherungsnummer": "ABC12345", "Telefon": "+4912345678", "Email": "test@email.de"},
            ),
          ],
        ),
      ];
      await saveCategories();
    }
    notifyListeners();
  }

  Future<void> saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_categories.map((c) => c.toJson()).toList());
    await prefs.setString(_storageKey, encodedData);
  }

  double get aboMonthlyTotal {
    return _categories
        .where((cat) => cat.mainType == MainCategoryType.subscription)
        .expand((cat) => cat.documents)
        .map((doc) {
          if (doc.cost == null) return 0.0;
          final interval = doc.interval?.toLowerCase() ?? "monatlich";
          if (interval.contains("quartal")) return doc.cost! / 3.0;
          if (interval.contains("jahr")) return doc.cost! / 12.0;
          return doc.cost!;
        })
        .fold(0.0, (prev, cost) => prev + cost);
  }

  double get nonAboMonthlyAverage {
    final monthlyCosts = _categories
        .where((cat) => cat.mainType != MainCategoryType.subscription)
        .expand((cat) => cat.documents)
        .map((doc) {
          if (doc.cost == null) return null;
          final interval = doc.interval?.toLowerCase() ?? "monatlich";
          if (interval.contains("quartal")) return doc.cost! / 3.0;
          if (interval.contains("jahr")) return doc.cost! / 12.0;
          return doc.cost!;
        })
        .where((cost) => cost != null)
        .cast<double>()
        .toList();

    if (monthlyCosts.isEmpty) return 0.0;

    final total = monthlyCosts.fold(0.0, (prev, cost) => prev + cost);
    return total / monthlyCosts.length;
  }

  List<SmartDocument> get nextDueDocs {
    final now = DateTime.now();
    var futureDocs = _categories
        .expand((cat) => cat.documents)
        .where((doc) => doc.nextDueDate != null && doc.nextDueDate!.isAfter(now))
        .toList();

    futureDocs.sort((a, b) => a.nextDueDate!.compareTo(b.nextDueDate!));
    return futureDocs;
  }

  void addCategory({
    required MainCategoryType mainType,
    required String name,
    required String iconName,
    required String colorHex,
    required Map<String, String> extraFields,
    required List<DocumentAttachment> attachments,
  }) {
    final costString = extraFields["Betrag"]?.replaceAll(',', '.');
    final firstDoc = SmartDocument(
      title: name,
      cost: costString != null ? double.tryParse(costString) : null,
      interval: extraFields["Frequenz"],
      extractedFields: extraFields,
      attachments: attachments,
    );

    final newCat = SmartCategory(
      mainType: mainType,
      name: name,
      iconName: iconName,
      colorHex: colorHex,
      documents: [firstDoc],
    );

    _categories.add(newCat);
    saveCategories();
    notifyListeners();
  }

  void updateCategory({
    required SmartCategory originalCategory,
    required SmartDocument updatedDoc,
    required String icon,
    required String color,
  }) {
    final index = _categories.indexWhere((c) => c.id == originalCategory.id);
    if (index != -1) {
      _categories[index].documents[0] = updatedDoc;
      _categories[index].name = updatedDoc.title;
      _categories[index].iconName = icon;
      _categories[index].colorHex = color;
      saveCategories();
      notifyListeners();
    }
  }

  void deleteCategoryById(String id) {
    _categories.removeWhere((cat) => cat.id == id);
    saveCategories();
    notifyListeners();
  }
}
