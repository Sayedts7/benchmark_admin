import 'package:flutter/cupertino.dart';

class PaginationProvider with ChangeNotifier {
  int selectedPageNumber = 1;
  int itemsPerPage = 10;
  String? lastDocumentId;

  int _totalDocuments = 0;

  void setTotalDocuments(int total) {
    _totalDocuments = total;
    notifyListeners();
  }

  int get totalDocuments => _totalDocuments;
  void setItemsPerPage(int items) {
    itemsPerPage = items;
    selectedPageNumber = 1;
    lastDocumentId = null;
    notifyListeners();
  }
  void setPageNumber(){
    selectedPageNumber = 1;
    notifyListeners();
  }

  void setSelectedPageNumber(int pageNumber) {
    selectedPageNumber = pageNumber;
    notifyListeners();
  }

  void setLastDocumentId(String id) {
    lastDocumentId = id;
    notifyListeners();
  }
}
