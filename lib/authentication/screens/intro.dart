import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playserve_mobile/global_theme.dart';
import 'package:playserve_mobile/authentication/screens/login.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 Logo di atas
                Image.asset(
                  'assets/image/logo2.png',
                  width: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),

                // 🎾 Ilustrasi utama
                Image.asset(
                  'assets/image/intro1.png',
                  width: 240,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),

                // 📝 Teks deskripsi
                Text(
                  "Finding a game has never been this easy or this fast. Simply find a player, book the court, and get playing.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // 🔘 Tombol Next
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const IntroPage2(),
                          transitionsBuilder:
                              (_, animation, __, child) => SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            )),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 26,
                      backgroundColor: limegreen,
                      child: Icon(Icons.arrow_forward, color: blue1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 Logo di atas
                Image.asset(
                  'assets/image/logo2.png',
                  width: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),

                // 🗣️ Ilustrasi utama
                Image.asset(
                  'assets/image/intro2.png',
                  width: 260,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),

                // 📝 Teks deskripsi
                Text(
                  "Connect with the right players, join conversations exclusive to your favorite courts, and discover local groups to keep the rally going.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // 🔘 Tombol Next ke Login
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const LoginPage(),
                          transitionsBuilder:
                              (_, animation, __, child) => SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            )),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 26,
                      backgroundColor: limegreen,
                      child: Icon(Icons.arrow_forward, color: blue1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}