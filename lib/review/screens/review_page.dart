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
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1F63),
        elevation: 0,
        title: const Text(
          "Court Reviews",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: const ReviewList(),

      bottomNavigationBar: isAdmin
          ? const MainNavbarAdmin(currentIndex: 3)
          : const MainNavbar(currentIndex: 4),
    );
  }
}