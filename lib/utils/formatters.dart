import 'package:intl/intl.dart';

final currencyFormat = NumberFormat.currency(locale: 'de_DE', symbol: '€');
final shortMonthDayFormat = DateFormat('dd MMM', 'de_DE');

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
