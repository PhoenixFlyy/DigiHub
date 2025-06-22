import 'package:flutter/material.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

IconData getIconData(String iconName) {
  switch (iconName.toLowerCase()) {
    case 'icloud':
    case 'cloud':
      return Icons.cloud_outlined;
    case 'shield':
      return Icons.shield_outlined;
    case 'folder':
      return Icons.folder_outlined;
    case 'doc.text':
      return Icons.article_outlined;
    case 'apple.logo':
      return Icons.apple;
    case 'star':
      return Icons.star_border;
    case 'repeat':
      return Icons.repeat;
    case 'chart.bar':
      return Icons.bar_chart;
    default:
      return Icons.help_outline;
  }
}

final List<String> availableIconNames = ['folder', 'cloud', 'article', 'apple', 'shield', 'star'];
