import 'package:digi_hub/models/smart_document.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../utils/icon_mapper.dart';
import 'main_category_type.dart';

class SmartCategory {
  String id;
  MainCategoryType mainType;
  String name;
  IconData icon;
  String colorHex;
  List<SmartDocument> documents;

  SmartCategory({
    String? id,
    required this.mainType,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.documents,
  }) : id = id ?? const Uuid().v4();

  double get totalCost {
    return documents.fold(0.0, (sum, doc) => sum + (doc.cost ?? 0.0));
  }

  factory SmartCategory.fromJson(Map<String, dynamic> json) {
    return SmartCategory(
      id: json['id'],
      mainType: MainCategoryType.values[json['mainType']],
      name: json['name'],
      icon: stringToIcon(json['iconName']),
      colorHex: json['colorHex'],
      documents: (json['documents'] as List).map((i) => SmartDocument.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mainType': mainType.index,
      'name': name,
      'iconName': iconToString(icon),
      'colorHex': colorHex,
      'documents': documents.map((i) => i.toJson()).toList(),
    };
  }
}