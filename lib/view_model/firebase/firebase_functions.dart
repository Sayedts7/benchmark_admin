import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<String?> getUserStatus(String email) async {
    final QuerySnapshot querySnapshot = await _db
        .collection('User')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0]['status'].toString();
    } else {
      return null;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      print('Checking email: $email');
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('User')
          .where('signUpWith', isEqualTo: 'email')
          .limit(1) // Limiting to 1 document for efficiency
          .get();

      print('Query snapshot: ${querySnapshot.docs}');
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle errors appropriately, e.g., log the error or show a message to the user
      print('Error checking email existence: $e');
      return false;
    }
  }
// Fetch a single user by ID
//   Future<UserData?> fetchUserById(String id) async {
//     try {
//       DocumentSnapshot docSnapshot = await _db.collection('users').doc(id).get();
//       if (docSnapshot.exists) {
//         return UserData.fromJson(docSnapshot.data() as Map<String, dynamic>);
//       }
//       return null;
//     } catch (e) {
//       print('Error fetching user: $e');
//       return null;
//     }
//   }



  Future<void> setNotifications(String receiverId, String title, String message, String projectId) async {

    var id = DateTime.now().millisecondsSinceEpoch.toString();
    await _db.collection('Notifications').doc(id).set({
      'id': id,
      'fromId': FirebaseAuth.instance.currentUser!.uid,
      'toId': receiverId,
      'title': title,
      'message': message,
      'date': DateTime.now(),
      'read': false,
      'projectId':projectId,
    });
  }

  Future<String?> getTokenFromUserCollection(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('User').doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        return data['token'] as String?;
      }
    } catch (e) {
      print('Error getting token: $e');
    }
    return null;
  }

}

//
// child: StreamBuilder<QuerySnapshot>(
// stream:   FirebaseFirestore.instance
//     .collection('Notifications')
//     .where('toId', isEqualTo: 'admin')
//     .orderBy('date', descending: true).snapshots(),
// builder: (context, snapshot) {
// return ListView.builder(
// itemCount: snapshot.data!.docs.length,
// itemBuilder: (context, index) {
// return Column(
// children: [
// ListTile(
// leading: Icon(Icons.notifications),
// title: Text(snapshot.data!.docs[index]['title']),
// subtitle: Text('sa'),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal:5.0),
// child: Divider(),
// ),
//
// ],
// );
// },
// );
// }
// ),
