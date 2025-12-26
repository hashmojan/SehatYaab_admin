// class ReportCard extends StatelessWidget {
//   final QueryDocumentSnapshot report;
//   ReportCard({required this.report});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 15),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Report by: ${report['patientName']}",
//                     style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.lightPrimary)),
//                 Text("Date: ${report['timestamp'].toString().substring(0, 10)}",
//                     style: TextStyle(color: Colors.grey, fontSize: 12)),
//               ],
//             ),
//             Divider(),
//             Text("Doctor Accused: ${report['doctorName']}",
//                 style: TextStyle(color: AppColors.terracottaRed, fontWeight: FontWeight.w600)),
//             SizedBox(height: 10),
//             Text("Issue:", style: TextStyle(fontWeight: FontWeight.bold)),
//             Text("${report['reason']}", style: TextStyle(color: Colors.black87)),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 // Action 1: Dismiss
//                 TextButton(
//                   onPressed: () => _deleteReport(report.id),
//                   child: Text("Dismiss", style: TextStyle(color: AppColors.lightSecondary)),
//                 ),
//                 Spacer(),
//                 // Action 2: Ban Doctor (Using your RoundButton style)
//                 RoundButton(
//                   width: 150, height: 40,
//                   buttonColor: AppColors.redColor,
//                   title: "Suspend Doctor",
//                   onPress: () => _suspendDoctor(report['doctorId'], report.id),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _deleteReport(String id) {
//     FirebaseFirestore.instance.collection('reports').doc(id).delete();
//   }
//
//   void _suspendDoctor(String doctorId, String reportId) async {
//     // 1. Mark doctor as banned
//     await FirebaseFirestore.instance.collection('users').doc(doctorId).update({
//       'isBanned': true,
//       'isVerified': false, // Remove from search results immediately
//     });
//     // 2. Clean up the report
//     _deleteReport(reportId);
//     Get.snackbar("Action Taken", "Doctor has been suspended.", backgroundColor: AppColors.white);
//   }
// }