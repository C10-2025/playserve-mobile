import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';          
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'global_theme.dart';
import 'package:playserve_mobile/authentication/screens/splash_screen.dart';

void main() {
  runApp(const PlayServeApp());
}

class PlayServeApp extends StatelessWidget {
  const PlayServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PlayServe',
        theme: globalTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
