import 'dart:async';
import 'package:benchmark_estimate_admin_panel/utils/common_function.dart';
import 'package:benchmark_estimate_admin_panel/view/landing_view/landing_view_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view_model/firebase/auth_services.dart';
import '../../view_model/firebase/firebase_functions.dart';
import '../../view_model/provider/admin_provider.dart';
import '../login_view.dart';

class SplashServices {
  void isLogin(BuildContext context) async {
    print('--------------------------');
    CommonFunctions.checkProjectsAndCreateNotifications();
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('rememberMe'));
    if (prefs.getBool('rememberMe') == false ||
        prefs.getBool('rememberMe') == null) {
      AuthServices().signOut();
      Timer(
          const Duration(seconds: 1),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginView())));
    } else {
      print(user != null);
      if (user != null) {
        // String? phoneNull = await getPhone();
        // String? status = await FirestoreService().getUserStatus(user.email!);

        // if(status == 'Activate'){
        //   // if(phoneNull == ''){
        //   //   Timer(const Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInWithPhone()))  );
        //   //
        //   // }else{
        //   Timer(const Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LandingView()))  );
        //
        //   // }
        // }else{

        final adminProvider =
            Provider.of<AdminProvider>(context, listen: false);
       await adminProvider.fetchAdminData(FirebaseAuth.instance.currentUser!.uid);

        Timer(
            const Duration(seconds: 1),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LandingView())));
        // showDialogStatus(context, 'User is deactivated by admin, Kindly contact admin');
      }

      // }
      else {
        Timer(
            const Duration(seconds: 1),
            () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginView())));
      }
    }
  }
}
