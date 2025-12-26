import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../components/app_colors.dart';
import '../report/report_screen.dart';
import '../verificatoin/verification_screen.dart';
import '../auth_screen/admin_login.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // Updated list to include a Dashboard Overview if needed later
  final List<Widget> _pages = [
    const VerificationScreen(),
     ReportsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      body: Row(
        children: [
          // Professional Sidebar using NavigationRail
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: NavigationRail(
              backgroundColor: AppColors.lightPrimary, // Your brand color
              elevation: 5,
              extended: true, // Shows labels next to icons for a more professional desktop feel
              minExtendedWidth: 200,
              useIndicator: true,
              indicatorColor: Colors.white.withOpacity(0.2),

              // BRANDING AT THE TOP OF THE RAIL
              leading: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.health_and_safety, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "SehatYaab",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "ADMIN PANEL",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 10,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),

              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) => setState(() => _selectedIndex = index),

              unselectedIconTheme: const IconThemeData(color: Colors.white60),
              selectedIconTheme: const IconThemeData(color: Colors.white),
              unselectedLabelTextStyle: GoogleFonts.poppins(color: Colors.white60, fontSize: 13),
              selectedLabelTextStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600
              ),

              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.fact_check_outlined),
                  selectedIcon: Icon(Icons.fact_check),
                  label: Text("Verifications"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.assignment_late_outlined),
                  selectedIcon: Icon(Icons.assignment_late),
                  label: Text("Reports"),
                ),
              ],

              // LOGOUT BUTTON AT THE BOTTOM
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: IconButton(
                      onPressed: () => _handleLogout(context),
                      icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                      tooltip: "Logout",
                    ),
                  ),
                ),
              ),
            ),
          ),

          // MAIN CONTENT AREA
          Expanded(
            child: Column(
              children: [
                // Top Header Bar for the main content area
                Container(
                  height: 70,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Text(
                        _selectedIndex == 0 ? "Doctor Verification" : "System Reports",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      const Spacer(),
                      // Admin Profile Quick View
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("System Admin",
                                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
                              Text("Active Now",
                                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.green)),
                            ],
                          ),
                          const SizedBox(width: 12),
                          const CircleAvatar(
                            backgroundColor: Color(0xFFE2E8F0),
                            child: Icon(Icons.person, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // The actual page content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _pages[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to exit the admin panel?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                try {
                  // Sign out from Firebase
                  await FirebaseAuth.instance.signOut();
                  
                  // Close dialog
                  Navigator.pop(context);
                  
                  // Navigate to login screen
                  Get.offAll(() => AdminLoginScreen());
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error logging out: ${e.toString()}")),
                  );
                }
              },
              child: const Text("Logout", style: TextStyle(color: Colors.white))
          ),
        ],
      ),
    );
  }
}