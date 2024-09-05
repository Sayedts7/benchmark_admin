import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProvider with ChangeNotifier {
  bool categoryE = false;
  bool ordersE = false;
  bool clientsE = false;
  bool paymentE = false;
  bool adminsE = false;

  Future<void> fetchAdminData(String uid) async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Admins')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      categoryE = data['CategoryE'] ?? false;
      ordersE = data['OrderE'] ?? false;
      clientsE = data['ClientsE'] ?? false;
      paymentE = data['PaymentE'] ?? false;
      adminsE = data['superAdmin'] ?? false;

      print(categoryE);
      print('---------------------------------------------------------0');
      print(ordersE);
      print(clientsE);
      print(paymentE);
      print(paymentE);

      notifyListeners();
    }
  }
}
