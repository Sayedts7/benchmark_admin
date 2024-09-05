import 'package:benchmark_estimate_admin_panel/view/add_category/add_category_view.dart';
import 'package:benchmark_estimate_admin_panel/view/admins/admin_view.dart';
import 'package:benchmark_estimate_admin_panel/view/chat/chat_view.dart';
import 'package:benchmark_estimate_admin_panel/view/clients/clients_view.dart';
import 'package:benchmark_estimate_admin_panel/view/landing_view/landing_view_screen.dart';
import 'package:benchmark_estimate_admin_panel/view/login_view.dart';
import 'package:benchmark_estimate_admin_panel/view/splash/splash_screen.dart';
import 'package:benchmark_estimate_admin_panel/view_model/firebase/global.dart';
import 'package:benchmark_estimate_admin_panel/view_model/firebase/push_notifications.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/admin_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/category_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/category_tag_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/checkbox_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/file_picker_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/landing_view_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/loader_view_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/obsecure_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/order_type_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/pagination_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/payment_type_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/user_profile_edit%20_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future FirebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    notificationServices.requestAndRegisterNotification();

    // TODO: implement initState
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CheckBoxProvider()),
      ChangeNotifierProvider(create: (_) => ObscureProvider()),
      ChangeNotifierProvider(create: (_) => FilePickerProvider()),
      ChangeNotifierProvider(create: (_) => LoaderViewProvider()),
      ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => LandingViewProvider()),
      // ChangeNotifierProvider(create: (_) => ChatProvider('', context)),
      ChangeNotifierProvider(create: (_) => OrderStatusProvider()),
      ChangeNotifierProvider(create: (_) => PaymentTypeProvider()),
      ChangeNotifierProvider(create: (_) => PaginationProvider()),
      ChangeNotifierProvider(create: (_) => CategoryTagProvider()),
      ChangeNotifierProvider(create: (_) => AdminCheckBoxProvider()),
      ChangeNotifierProvider(create: (_) => AdminProvider()),
      ChangeNotifierProvider(create: (_) => NotificationServices()),





    ],
      child: GetMaterialApp(
          title: 'Benchmark Estimate Admin',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,

          ),
          home:  SplashScreen()
      ),);
  }
}
