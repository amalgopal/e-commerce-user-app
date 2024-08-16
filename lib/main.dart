import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopy_client/controller/home_controller.dart';
import 'package:shopy_client/controller/login_controller.dart';
import 'package:shopy_client/controller/purchase_controller.dart';
import 'package:shopy_client/firebase_option.dart';
import 'package:shopy_client/pages/login_page.dart';
import 'package:shopy_client/pages/register_page.dart';

void main() async {
  //initializing get storage
  await GetStorage.init();
  //initializing firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);

  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(PurchaseController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
