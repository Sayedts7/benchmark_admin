// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class CategoryProvider with ChangeNotifier {
//   List<Map<String, dynamic>> categories = [];
//   List<int> selectedCategoryIndexes = [];
//   bool isSchedulingSelected = false;
//   TextEditingController workingHoursController = TextEditingController();
//   TextEditingController workingDaysController = TextEditingController();
//
//   void toggleCategory(int index) {
//     if (categories[index]['categoryName'] == 'Scheduling') {
//       isSchedulingSelected = !isSchedulingSelected;
//       if (isSchedulingSelected) {
//         selectedCategoryIndexes.clear();
//       }
//     } else {
//       if (selectedCategoryIndexes.contains(index)) {
//         selectedCategoryIndexes.remove(index);
//       } else {
//         selectedCategoryIndexes.add(index);
//       }
//       isSchedulingSelected = false;
//     }
//     notifyListeners();
//   }
//
//   void setWorkingHours(String hours) {
//     workingHoursController.text = hours;
//     notifyListeners();
//   }
//
//   void setWorkingDays(String days) {
//     workingDaysController.text = days;
//     notifyListeners();
//   }
//
//   void loadCategoriesFromFirebase() async {
//     final snapshot = await FirebaseFirestore.instance.collection('Categories').get();
//     final categories = snapshot.docs.map((doc) => doc.data()).toList();
//
//     // Implement loading categories from Firebase
//     // Once loaded, call notifyListeners()
//   }
//
//   @override
//   void dispose() {
//     workingHoursController.dispose();
//     workingDaysController.dispose();
//     super.dispose();
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProvider with ChangeNotifier {
  List<String> categories = [];
  Map<String, List<String>> subCategories = {};
  List<int> selectedCategoryIndexes = [];
  List<List<bool>> selectedOptions = [];
  bool sch = false;

  Future<void> fetchCategories() async {
    final categoriesSnapshot = await FirebaseFirestore.instance.collection('Categories').get();
    categories = categoriesSnapshot.docs.map((doc) => doc['categoryName'] as String).toList();
    subCategories = {
      for (var doc in categoriesSnapshot.docs)
        doc['categoryName']: List<String>.from(doc['subCategory'])
    };
    selectedOptions = List.generate(categories.length, (index) => List.generate(subCategories[categories[index]]!.length, (index) => true));
    notifyListeners();
  }

  void toggleCategorySelection(int index) {
    if (categories[index] == 'Scheduling') {
      selectedCategoryIndexes = [index];
      sch = true;
    } else {
      selectedCategoryIndexes.removeWhere((element) => categories[element] == 'Scheduling');

      if (selectedCategoryIndexes.contains(index)) {
        selectedCategoryIndexes.remove(index);

      } else {
        selectedCategoryIndexes.add(index);
      }
      sch = false;
    }
    notifyListeners();
  }

  void toggleSubCategorySelection(int categoryIndex, int subCategoryIndex) {
    selectedOptions[categoryIndex][subCategoryIndex] = !selectedOptions[categoryIndex][subCategoryIndex];
    notifyListeners();
  }
}
