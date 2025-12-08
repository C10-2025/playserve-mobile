import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'global_theme.dart';
import 'package:playserve_mobile/authentication/screens/splash_screen.dart';
import 'package:playserve_mobile/authentication/screens/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create ONE CookieRequest instance for the whole app
  final cookieRequest = CookieRequest();

  // Immediately re-sync admin status on startup (digunakan untuk modul yang mengambil status
  // admin dari cookieRequest global seperti Review)
  try {
    final adminResp = await cookieRequest.get(
      "https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id/auth/check_admin_status/",
    );

    cookieRequest.jsonData["is_admin"] = adminResp["is_admin"] ?? false;
  } catch (e) {
    // If request fails (likely not logged in), default to false
    cookieRequest.jsonData["is_admin"] = false;
  }

  runApp(PlayServeApp(cookieRequest: cookieRequest));
}

class PlayServeApp extends StatelessWidget {
  final CookieRequest cookieRequest;

  const PlayServeApp({super.key, required this.cookieRequest});

  @override
  Widget build(BuildContext context) {
    return Provider<CookieRequest>.value(
      value: cookieRequest, // global CookieRequest instance 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PlayServe',
        theme: globalTheme,
        home: const SplashScreen(),

        routes: {
          '/admin/users': (context) => const AdminUsersPage(),
          '/admin/reviews': (context) => const AdminReviewsPage(),
          '/admin/community': (context) => const AdminCommunityPage(),
        },
      ),
    );
  }
}