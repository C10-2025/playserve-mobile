import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';          
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/screens/login.dart';
import 'package:playserve_mobile/screens/register.dart';
import 'package:provider/provider.dart';

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
        title: 'PlayServe Login',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo,
          ).copyWith(
            secondary: const Color(0xFFB8D243),
          ),

          // 👇 GLOBAL FONT = INTER
          textTheme: GoogleFonts.interTextTheme(),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
