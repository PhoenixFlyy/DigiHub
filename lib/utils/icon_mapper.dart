import 'package:flutter/cupertino.dart';

const Map<String, IconData> _iconMap = {
  'repeat': CupertinoIcons.repeat,
  'chart_bar': CupertinoIcons.chart_bar,
  'money_dollar_circle': CupertinoIcons.money_dollar_circle,
  'house_fill': CupertinoIcons.house_fill,
  'car_fill': CupertinoIcons.car_fill,
  'heart_fill': CupertinoIcons.heart_fill,
  'book_fill': CupertinoIcons.book_fill,
  'gift_fill': CupertinoIcons.gift_fill,
  'shopping_cart': CupertinoIcons.shopping_cart,
};

IconData stringToIcon(String iconName) {
  return _iconMap[iconName] ?? CupertinoIcons.question_circle;
}

String iconToString(IconData icon) {
  return _iconMap.keys.firstWhere(
        (key) => _iconMap[key] == icon,
    orElse: () => 'question_circle',
  );
}