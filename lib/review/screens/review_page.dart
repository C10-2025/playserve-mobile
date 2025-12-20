import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../widgets/review_list.dart';
import 'package:playserve_mobile/main_navbar.dart';
import 'package:playserve_mobile/main_navbar_admin.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final bool isAdmin = request.jsonData["is_admin"] == true;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1F63),

      appBar: AppBar(
        automaticallyImplyLeading: false, // Navigate only with navbar
        backgroundColor: const Color(0xFF0A1F63),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Court Reviews",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 3,
            width: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFB0D235), // green accent
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: const ReviewList(), // ReviewList widget
      ),

      bottomNavigationBar: isAdmin
          ? const MainNavbarAdmin(currentIndex: 3)
          : const MainNavbar(currentIndex: 4),
    );
  }
}