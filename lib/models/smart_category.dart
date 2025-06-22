import 'package:digi_hub/models/smart_document.dart';
import 'package:uuid/uuid.dart';

import 'main_category_type.dart';

class SmartCategory {
  String id;
  MainCategoryType mainType;
  String name;
  String iconName;
  String colorHex;
  List<SmartDocument> documents;

  SmartCategory({
    String? id,
    required this.mainType,
    required this.name,
    required this.iconName,
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
      iconName: json['iconName'],
      colorHex: json['colorHex'],
      documents: (json['documents'] as List).map((i) => SmartDocument.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mainType': mainType.index,
      'name': name,
      'iconName': iconName,
      'colorHex': colorHex,
      'documents': documents.map((i) => i.toJson()).toList(),
    };
  }
}
