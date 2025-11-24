import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playserve_mobile/matchmaking/widgets/filter_button.dart';
import 'package:playserve_mobile/matchmaking/widgets/player_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF042A76),
              Color(0xFF0A4AA3),
            ],
          ),
        ),

        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/bg_pattern.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    Text(
                      "FIND A MATCH",
                      style: GoogleFonts.inter(
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FilterButton("TOP PICKS\nFOR YOU"),
                        SizedBox(width: 12),
                        FilterButton("SENT\nREQUESTS"),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Expanded(
                      child: ListView(
                        children: const [
                          PlayerCard(),
                          SizedBox(height: 20),
                          PlayerCard(),
                          SizedBox(height: 20),
                          PlayerCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
