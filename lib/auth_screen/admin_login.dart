import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/app_colors.dart';
import '../components/round_button.dart';
import '../view_model/admin_login.dart';

class AdminLoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AdminLoginViewModel viewModel = Get.put(AdminLoginViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      // Added the SehatYaab Admin Branding at the top
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "SehatYaab Admin",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.lightPrimary,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 450, // Slightly wider for better proportions
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Subtle Icon to ground the UI
                Icon(Icons.admin_panel_settings_rounded,
                    size: 60,
                    color: AppColors.lightPrimary),
                const SizedBox(height: 16),

                Text(
                  "System Authentication",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Enter your credentials to manage the portal",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field with Icon
                _buildTextField(
                  controller: emailController,
                  hint: "Admin Email",
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),

                // Password Field with Icon
                _buildTextField(
                  controller: passwordController,
                  hint: "Password",
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),
                const SizedBox(height: 10),

                // Forgot Password link (common in professional UI)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: AppColors.lightPrimary),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Obx(() => RoundButton(
                  title: viewModel.isLoading.value
                      ? "Authenticating..."
                      : "Login to Dashboard",
                  width: double.infinity, // Full width button for modern look
                  height: 55,
                  borderRadius: 12,
                  onPress: () {
                    viewModel.loginAdmin(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for consistent, professional text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.poppins(fontSize: 15),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.lightPrimary, size: 20),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
      ),
    );
  }
}