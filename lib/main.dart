import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart'; // Required
import 'package:sehatyaab_admin/admin_dashboard/admin_dashboard.dart';
import 'auth_screen/admin_login.dart';
import 'components/app_colors.dart';

void main() async {
  // 1. Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase for Web
  // REPLACED: Added the necessary initialization for Web compatibility
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY", // Replace with your actual Web API Key
        authDomain: "sehatyaab-xxxx.firebaseapp.com",
        projectId: "sehatyaab-xxxx",
        storageBucket: "sehatyaab-xxxx.appspot.com",
        messagingSenderId: "xxxxxx",
        appId: "1:xxxxxx:web:xxxxxx",
        measurementId: "G-xxxxxx"
    ),
  );

  // 3. Put your ThemeController into GetX memory
  Get.put(ThemeController());

  runApp(const MyApp());
}

// Simple ThemeController to avoid errors with AppColors
class ThemeController extends GetxController {
  var isDarkMode = false.obs;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SehatYaab Admin Portal',
      theme: ThemeData(
        primaryColor: AppColors.lightPrimary,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        useMaterial3: true,
        // Optional: Adding a global font to match your verification screen
        fontFamily: 'Poppins',
      ),
      // Logic: If you want security, start with AdminLoginScreen()
      // For now, I'll leave it as AdminDashboard() as per your request
      home: AdminLoginScreen(),
    );
  }
}