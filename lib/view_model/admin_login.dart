import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../admin_dashboard/admin_dashboard.dart';

class AdminLoginViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;

  /// Login Admin with email & password
  Future<void> loginAdmin(String email, String password) async {
    try {
      isLoading.value = true;

      // 1️⃣ Firebase Auth Sign-In
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;

      if (uid == null) {
        Get.snackbar("Login Failed", "User ID not found");
        return;
      }

      // 2️⃣ Get user document from Firestore
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        Get.snackbar("Error", "Admin record not found");
        await _auth.signOut();
        return;
      }

      final role = userDoc.data()?['role'] as String?;

      // 3️⃣ Check role
      if (role == 'admin') {
        // ✅ Navigate to Admin Dashboard
        Get.offAll(() => AdminDashboard());
      } else {
        // ❌ Not admin, sign out
        await _auth.signOut();
        Get.snackbar("Access Denied", "You are not an admin");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Something went wrong");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Optional: Auto-login if admin is already signed in
  Future<void> autoLoginIfAdmin() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final role = userDoc.data()?['role'] as String?;
      if (role == 'admin') {
        Get.offAll(() => AdminDashboard());
      } else {
        await _auth.signOut();
      }
    }
  }
}
