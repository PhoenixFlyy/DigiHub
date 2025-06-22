enum MainCategoryType {
  insurance,
  subscription,
  contract,
  invoice,
  custom;

  String get rawValue {
    switch (this) {
      case MainCategoryType.insurance:
        return 'Versicherung';
      case MainCategoryType.subscription:
        return 'Abo';
      case MainCategoryType.contract:
        return 'Vertrag';
      case MainCategoryType.invoice:
        return 'Rechnung';
      case MainCategoryType.custom:
        return 'Custom';
    }
  }

  static MainCategoryType fromRawValue(String rawValue) {
    return MainCategoryType.values.firstWhere((e) => e.rawValue == rawValue, orElse: () => MainCategoryType.custom);
  }
}
