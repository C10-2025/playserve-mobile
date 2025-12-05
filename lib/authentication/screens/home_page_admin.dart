import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playserve_mobile/global_theme.dart';
import 'package:playserve_mobile/main_navbar_admin.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // 🎾 Title Section
                Center(
                  child: Column(
                    children: [
                      Text(
                        "COURTSIDE",
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "CONTROL.",
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: limegreen,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Image.asset(
                  'assets/image/background.png',
                  width: 250,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 28),

                // 🔹 Feature Buttons (Admin Tools)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FeatureButton(
                      imagePath: 'assets/image/user_admin.png',
                      label: 'Users',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin/users');
                      },
                    ),
                    _FeatureButton(
                      imagePath: 'assets/image/booking.png',
                      label: 'Booking',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin/bookings');
                      },
                    ),
                    _FeatureButton(
                      imagePath: 'assets/image/review.png',
                      label: 'Review',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin/reviews');
                      },
                    ),
                    _FeatureButton(
                      imagePath: 'assets/image/community.png',
                      label: 'Community',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin/community');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🟩 Highlight Box (Admin Quick Overview)
                Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: limegreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      "System Overview",
                      style: GoogleFonts.inter(
                        color: blue1,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ⚙️ Payment Processes Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Processes",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/admin/payments');
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Payment cards (placeholder)
                for (int i = 0; i < 3; i++)
                  Container(
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                const SizedBox(height: 80),
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
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
