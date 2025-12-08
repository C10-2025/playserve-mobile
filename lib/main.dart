import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'global_theme.dart';
import 'package:playserve_mobile/authentication/screens/splash_screen.dart';
import 'package:playserve_mobile/authentication/screens/admin_page.dart'; // <-- tambahin ini (sesuaikan path)

void main() {
  runApp(const PlayServeApp());
}

class PlayServeApp extends StatelessWidget {
  const PlayServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<CookieRequest>(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PlayServe',
        theme: globalTheme,
        // halaman pertama tetap SplashScreen
        home: const SplashScreen(),

        // 🔹 DAFTAR NAMED ROUTES
        routes: {
          '/admin/users': (context) => const AdminUsersPage(),
          '/admin/reviews': (context) => const AdminReviewsPage(),
          '/admin/community': (context) => const AdminCommunityPage(),
        },
      ),
    );
  }
}
