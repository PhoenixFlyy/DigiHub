import 'package:uuid/uuid.dart';

import 'document_attachment.dart';

class SmartDocument {
  String id;
  String title;
  double? cost;
  DateTime? nextDueDate;
  String? interval;
  Map<String, String> extractedFields;
  List<DocumentAttachment> attachments;

  SmartDocument({
    String? id,
    required this.title,
    this.cost,
    this.nextDueDate,
    this.interval,
    required this.extractedFields,
    List<DocumentAttachment>? attachments,
  }) : id = id ?? const Uuid().v4(),
       attachments = attachments ?? [];

  factory SmartDocument.fromJson(Map<String, dynamic> json) {
    return SmartDocument(
      id: json['id'],
      title: json['title'],
      cost: json['cost'],
      nextDueDate: json['nextDueDate'] != null ? DateTime.tryParse(json['nextDueDate']) : null,
      interval: json['interval'],
      extractedFields: Map<String, String>.from(json['extractedFields']),
      attachments: (json['attachments'] as List).map((i) => DocumentAttachment.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cost': cost,
      'nextDueDate': nextDueDate?.toIso8601String(),
      'interval': interval,
      'extractedFields': extractedFields,
      'attachments': attachments.map((i) => i.toJson()).toList(),
    };
  }
}
