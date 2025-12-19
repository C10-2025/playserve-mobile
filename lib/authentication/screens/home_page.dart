import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/screens/field_detail_screen.dart';
import 'package:playserve_mobile/booking/widgets/booking_field_card.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:playserve_mobile/community/screen/discover_communities_page.dart';
import 'package:playserve_mobile/booking/config.dart';
import 'package:playserve_mobile/global_theme.dart';
import 'package:playserve_mobile/main_navbar.dart';
import 'package:playserve_mobile/header.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PlayingField> _recommendedFields = [];
  bool _isLoadingFields = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecommendedFields();
  }

  Future<void> _loadRecommendedFields() async {
    try {
      final request = context.read<CookieRequest>();
      final service = BookingService(request, baseUrl: kBaseUrl);

      final response = await service.fetchFieldsPaginated(
        page: 1,
        pageSize: 3, // Only fetch first 3 fields
      );

      setState(() {
        _recommendedFields = response.fields
            .take(3)
            .toList(); // Ensure only 3 fields
        _isLoadingFields = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoadingFields = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding khusus header profile agar rapi
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: ProfileHeader(),
                ),

                // --- 1. HEADER SECTION (UBAH JADI STACK ALA ADMIN) ---
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Layer Belakang: Gambar Full Width + Opacity
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

                    // Layer Depan: Teks Judul
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            "FIND YOUR RIVAL.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "ACE THE COURT.", // Warna Hijau agar mirip Admin
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                              color: limegreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Content Wrapper
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Feature Buttons ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _FeatureButton(
                            imagePath: 'assets/image/match.png',
                            label: 'Match',
                            onTap: () {
                              // TODO: ke halaman match
                            },
                          ),
                          _FeatureButton(
                            imagePath: 'assets/image/booking.png',
                            label: 'Booking',
                            onTap: () {
                              // TODO: ke halaman booking
                            },
                          ),
                          _FeatureButton(
                            imagePath: 'assets/image/review.png',
                            label: 'Review',
                            onTap: () {
                              // TODO: ke halaman review
                            },
                          ),
                          _FeatureButton(
                            imagePath: 'assets/image/community.png',
                            label: 'Community',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DiscoverCommunitiesPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),


                      // --- 2. Container Hijau DIHAPUS ---
                      const SizedBox(height: 40),

                      // --- 3. Recommended Courts (TANPA PANAH) ---
                      Text(
                        "Recommended Courts",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18, // Sedikit diperbesar agar lebih jelas
                        ),
                      ),
                      
                      const SizedBox(height: 16),

                      // Recommended Courts Cards (Logic Tetap Sama)
                      if (_isLoadingFields)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        )
                      else if (_error != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'Failed to load courts',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      else
                        for (int i = 0; i < _recommendedFields.length; i++)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: BookingFieldCard(
                              field: _recommendedFields[i],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FieldDetailScreen(
                                    field: _recommendedFields[i],
                                  ),
                                ),
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
        bottomNavigationBar: const MainNavbar(currentIndex: 0),
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