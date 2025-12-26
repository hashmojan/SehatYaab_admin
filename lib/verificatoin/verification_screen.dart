import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/app_colors.dart'; // Ensure your primary colors are here

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Modern soft gray background

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Pending Verifications",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Review medical credentials carefully before approving access.",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('doctors')
                    .where('isVerified', isEqualTo: 'pending')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildStatusMessage("Error: ${snapshot.error}");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildStatusMessage("No pending registration requests.");
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildDoctorVerificationCard(doc.id, data);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A more professional Card Layout instead of a cramped Table
  Widget _buildDoctorVerificationCard(String uid, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blueGrey[50],
                  child: Icon(Icons.person, color: Colors.blueGrey[400]),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name']?.toString() ?? 'Unknown Doctor',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        data['specialization']?.toString() ?? 'General Physician',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.blueGrey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionIconButton(
                  icon: Icons.description_outlined,
                  label: "View Degree",
                  color: Colors.blue,
                  onTap: () => _openDocument(data['degreeUrl']),
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              children: [
                Expanded(
                  child: _buildDecisionButton(
                    label: "Reject",
                    color: Colors.red[50]!,
                    textColor: Colors.red,
                    onTap: () => _updateStatus(uid, 'rejected', data['name']),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildDecisionButton(
                    label: "Approve Member",
                    color: Colors.green[600]!,
                    textColor: Colors.white,
                    onTap: () => _updateStatus(uid, 'approved', data['name']),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionIconButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDecisionButton({required String label, required Color color, required Color textColor, required VoidCallback onTap}) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
    );
  }

  Widget _buildStatusMessage(String message) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.poppins(color: Colors.blueGrey[300], fontSize: 16),
      ),
    );
  }

  // --- Logic Methods Stay the same but with refined snackbars ---

  void _openDocument(dynamic url) async {
    if (url != null && url.toString().isNotEmpty) {
      final Uri uri = Uri.parse(url.toString());
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar("Error", "Could not open document",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    }
  }

  void _updateStatus(String uid, String status, dynamic name) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      DocumentReference drRef = FirebaseFirestore.instance.collection('doctors').doc(uid);
      batch.update(drRef, {'isVerified': status});
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      batch.update(userRef, {'isVerified': status});

      await batch.commit();

      Get.snackbar(
        "Verification Updated",
        "$name has been $status",
        snackPosition: SnackPosition.TOP,
        backgroundColor: status == 'approved' ? Colors.green[800] : Colors.red[800],
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
      );
    } catch (e) {
      Get.snackbar("Update Failed", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}