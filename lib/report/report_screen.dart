import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Matching dashboard background

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Patient Complaints",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    Text(
                      "Review and resolve issues reported by users",
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                // Quick Filter Badge
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.filter_list, color: AppColors.lightPrimary),
                )
              ],
            ),
            const SizedBox(height: 25),

            // Re-enabled and styled StreamBuilder
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('reports').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text("No active reports found", style: GoogleFonts.poppins(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var report = snapshot.data!.docs[index];
                      return _buildReportCard(context, report);
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

  Widget _buildReportCard(BuildContext context, QueryDocumentSnapshot report) {
    final data = report.data() as Map<String, dynamic>;
    // Mocking a priority for UI demonstration - usually based on report type
    bool isUrgent = data['severity'] == 'high';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: isUrgent ? Colors.red[50] : Colors.blue[50],
            child: Icon(
              isUrgent ? Icons.warning_amber_rounded : Icons.report_outlined,
              color: isUrgent ? Colors.red : Colors.blue,
            ),
          ),
          title: Text(
            data['subject'] ?? "General Issue",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text("From: ${data['userName'] ?? 'Anonymous'}", style: const TextStyle(fontSize: 13)),
          trailing: _buildPriorityBadge(isUrgent),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(72, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    "Complaint Details:",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data['description'] ?? "No description provided.",
                    style: GoogleFonts.poppins(height: 1.5, color: Colors.blueGrey[800]),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _actionButton("Mark as Resolved", Colors.green, Icons.check_circle_outline),
                      const SizedBox(width: 12),
                      _actionButton("Contact User", Colors.blueGrey, Icons.mail_outline),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(bool isUrgent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isUrgent ? "URGENT" : "NORMAL",
        style: TextStyle(
          color: isUrgent ? Colors.red : Colors.green,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _actionButton(String label, Color color, IconData icon) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 16, color: color),
        label: Text(label, style: TextStyle(color: color, fontSize: 12)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withOpacity(0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}