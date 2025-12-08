import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playserve_mobile/global_theme.dart';
import 'package:playserve_mobile/authentication/screens/intro.dart';
import 'package:playserve_mobile/authentication/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    final isLoggedIn = await _checkLoginStatus();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const HomePage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroPage1()),
      );
    }
  }

  Future<bool> _checkLoginStatus() async {
    final request = context.read<CookieRequest>();

    try {
      final response =
          await request.get('https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id/auth/check_login/');
      return response['is_logged_in'] == true;
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('username') != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Image.asset(
            'assets/image/logo.png',
            width: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
