import 'package:flutter/cupertino.dart';

class CategoryTagProvider with ChangeNotifier {
  final List<String> tag = [];
  late String category;
  late String id;

  List<String> get tags => tag;

  void addTag(String tagg) {
    tag.add(tagg);
    notifyListeners();
  }
  void savCategoryName(String category2, docId) {
    category = category2;
    id = docId;
    notifyListeners();
  }

  void removeTag(String tagg) {
    tag.remove(tagg);
    notifyListeners();
  }

  void clearTags() {
    tag.clear();
    notifyListeners();
  }
}
