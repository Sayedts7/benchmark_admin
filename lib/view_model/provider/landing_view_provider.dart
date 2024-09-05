import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LandingViewProvider with ChangeNotifier{
 late  int index = 1;
 late String docId;
 late String clientDocId = '';
 late String clientUid = '';

 bool clientOrders = false;
 late String searchQuery = '';

 void updateIndex(int value){
   index = value;
   notifyListeners();
 }

 void getDocId(String id){
   docId = id;
   notifyListeners();
 }
 void getClientId(String id, bool orders){
  clientDocId = id;
  clientOrders = orders;
  notifyListeners();
 }
 void changeClientOrderStatus(){
   clientOrders = false;
   notifyListeners();
 }
 void getClientUid(String id){
   clientUid = id;
   notifyListeners();
 }
void updateSearchQuery(String search){
   searchQuery = search;
   notifyListeners();
}





  // RxString searchQuery = "".obs;

  Set<String> _selectedProjectIds = {};

  Set<String> get selectedProjectIds => _selectedProjectIds;

  void toggleProjectSelection(String projectId) {
    if (_selectedProjectIds.contains(projectId)) {
      _selectedProjectIds.remove(projectId);
    } else {
      _selectedProjectIds.add(projectId);
    }
    print(_selectedProjectIds);
    notifyListeners();
  }
 void selectAllProjects(List<String> projectIds) {
   _selectedProjectIds = Set.from(projectIds);
   notifyListeners();
 }


 void clearSelection() {
    _selectedProjectIds.clear();
    notifyListeners();
  }

}