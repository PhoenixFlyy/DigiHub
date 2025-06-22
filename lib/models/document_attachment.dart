import 'dart:convert';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

class DocumentAttachment {
  String id;
  String fileName;
  String fileType;
  Uint8List fileData;

  DocumentAttachment({String? id, required this.fileName, required this.fileType, required this.fileData})
    : id = id ?? const Uuid().v4();

  factory DocumentAttachment.fromJson(Map<String, dynamic> json) {
    return DocumentAttachment(
      id: json['id'],
      fileName: json['fileName'],
      fileType: json['fileType'],
      fileData: base64Decode(json['fileData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'fileName': fileName, 'fileType': fileType, 'fileData': base64Encode(fileData)};
  }
}
