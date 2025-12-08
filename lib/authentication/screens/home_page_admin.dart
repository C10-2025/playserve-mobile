import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playserve_mobile/booking/screens/admin_field_list_screen.dart';
import 'package:playserve_mobile/community/screen/discover_communities_page.dart';
import 'package:playserve_mobile/global_theme.dart'; 
import 'package:playserve_mobile/main_navbar_admin.dart';
import 'package:playserve_mobile/profil/screens/delete_profile.dart';
import 'package:playserve_mobile/review/screens/review_page.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground( 
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        'assets/image/background.png',
                        width: double.infinity, 
                        fit: BoxFit.fitWidth, 
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(height: 150);
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            "COURTSIDE",
                            style: GoogleFonts.inter(
                              fontSize: 32, 
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            "CONTROL.",
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: limegreen,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FeatureButton(
                            imagePath: 'assets/image/users.png',
                            label: 'Users',
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const DeleteProfilePage())
                              );
                            },
                          ),
                          _FeatureButton(
                            imagePath: 'assets/image/booking.png',
                            label: 'Booking',
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const AdminFieldListScreen())
                              );
                            },
                          ),
                          _FeatureButton(
                            imagePath: 'assets/image/review.png',
                            label: 'Review',
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const ReviewPage())
                              );
                            },
                          ),
                          _FeatureButton(
                            imagePath: 'assets/image/community.png',
                            label: 'Community',
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const DiscoverCommunitiesPage())
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment Processes",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/admin/payments');
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      for (int i = 0; i < 3; i++)
                        Container(
                          height: 80,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: blue1.withOpacity(0.1),
                                child: const Icon(Icons.payment, color: blue1),
                              ),
                              title: Text(
                                // TODO BOOKING
                                "Transaction #${1001 + i}",
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: blue1),
                              ),
                              subtitle: Text("Pending confirmation", style: GoogleFonts.inter(fontSize: 12)),
                              trailing: const Text("\$ 50.00", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const MainNavbarAdmin(currentIndex: 0),
      ),
    );
  }
}

class _FeatureButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _FeatureButton({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                imagePath, 
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}