import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/widgets/review_list.dart';
import 'package:playserve_mobile/main_navbar.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use SafeArea to avoid notches
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(color: Color(0xFF1A2B4C)),
            child: SafeArea(
              top: true,
              child: Column(
                children: const [
                  // Top small header / spacing
                  SizedBox(height: 8),
                  // Expanded review list
                  Expanded(child: ReviewList()),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom navigation
      bottomNavigationBar: const MainNavbar(currentIndex: 4),
    );
  }
}
