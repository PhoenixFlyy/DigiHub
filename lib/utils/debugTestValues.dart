// TODO: This data will eventually come from a ViewModel or database
import 'package:flutter/cupertino.dart';

import '../models/main_category_type.dart';
import '../models/smart_category.dart';

final List<SmartCategory> categories = [
  SmartCategory(
    mainType: MainCategoryType.subscription,
    name: "Netflix",
    icon: CupertinoIcons.tv,
    colorHex: "E50914",
    documents: [],
  ),
  SmartCategory(
    mainType: MainCategoryType.subscription,
    name: "Spotify",
    icon: CupertinoIcons.music_note,
    colorHex: "1DB954",
    documents: [],
  ),
  SmartCategory(
    mainType: MainCategoryType.subscription,
    name: "Miete",
    icon: CupertinoIcons.house_fill,
    colorHex: "0A84FF",
    documents: [],
  ),
];