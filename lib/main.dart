import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'auth_screen/admin_login.dart';
import 'components/app_colors.dart';
import 'view_model/admin_login.dart';

void main() async {
  // 1. Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase for Web
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
        fontFamily: 'Poppins',
      ),
      home: const AuthCheckScreen(),
    );
  }
}

/// AuthCheckScreen checks if admin is already logged in
class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminLoginViewModel = Get.put(AdminLoginViewModel());
    
    return FutureBuilder(
      future: adminLoginViewModel.autoLoginIfAdmin(),
      builder: (context, snapshot) {
        // If snapshot has data, the auto-login was attempted
        if (snapshot.connectionState == ConnectionState.done) {
          // Return AdminLoginScreen - if admin is logged in, 
          // autoLoginIfAdmin will navigate away automatically
          return AdminLoginScreen();
        }
        
        // Show loading while checking authentication
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  "Initializing Admin Panel...",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}