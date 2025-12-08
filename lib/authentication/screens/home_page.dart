import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/screens/field_detail_screen.dart';
import 'package:playserve_mobile/booking/widgets/booking_field_card.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: 24),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          "FIND YOUR RIVAL.\nACE THE COURT.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Image.asset(
                          'assets/image/background.png',
                          width: 250,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _FeatureButton(
                        imagePath: 'assets/image/match.png',
                        label: 'Match',
                      ),
                      _FeatureButton(
                        imagePath: 'assets/image/booking.png',
                        label: 'Booking',
                      ),
                      _FeatureButton(
                        imagePath: 'assets/image/review.png',
                        label: 'Review',
                      ),
                      _FeatureButton(
                        imagePath: 'assets/image/community.png',
                        label: 'Community',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: limegreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recommended Courts",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Recommended Courts Cards
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

  const _FeatureButton({required this.imagePath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
