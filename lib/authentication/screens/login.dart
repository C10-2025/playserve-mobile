import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playserve_mobile/global_theme.dart';
import 'package:playserve_mobile/authentication/screens/home_page.dart';
import 'package:playserve_mobile/authentication/screens/home_page_admin.dart';
import 'package:playserve_mobile/authentication/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final double screenWidth = MediaQuery.of(context).size.width;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                width: screenWidth,
                child: Image.asset(
                  'assets/image/background.png',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      Image.asset(
                        'assets/image/logo2.png',
                        width: 180,
                        fit: BoxFit.contain,
                      ),

                      Image.asset(
                        'assets/image/login.png',
                        width: 260,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),

                      Text(
                        "Join thousands of players and find your next match by signing up for free.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 40),

                      RoundedInputField(
                        controller: _usernameController,
                        hintText: 'Username',
                        icon: Icons.person,
                        whiteIcon: false,
                      ),
                      const SizedBox(height: 16),

                      RoundedInputField(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                        whiteIcon: false,
                      ),
                      const SizedBox(height: 30),

                      _isLoading
                          ? const CircularProgressIndicator(color: limegreen)
                          : LimeButton(
                              text: "LOG IN",
                              onPressed: () async {
                                String username = _usernameController.text
                                    .trim();
                                String password = _passwordController.text
                                    .trim();

                                if (username.isEmpty || password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please fill in all fields.",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                setState(() => _isLoading = true);

                                final response = await request.login(
                                  "https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id/auth/login/",
                                  {'username': username, 'password': password},
                                );

                                setState(() => _isLoading = false);

                                if (request.loggedIn) {
                                  final adminCheck = await request.get(
                                    "https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id/auth/check_admin_status/",
                                  );

                                  if (context.mounted) {
                                    final bool isAdmin =
                                        adminCheck["is_admin"] ?? false;

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => isAdmin
                                            ? const HomePageAdmin()
                                            : const HomePage(),
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          backgroundColor: limegreen,
                                          content: Text(
                                            "Welcome, ${response['username'] ?? username}!",
                                            style: const TextStyle(
                                              color: blue1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                  }
                                } else {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        title: const Text(
                                          'Login Failed',
                                          style: TextStyle(
                                            color: blue1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(
                                          response['message'] ??
                                              'Invalid username or password.',
                                          style: const TextStyle(color: blue1),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                color: limegreen,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                      const SizedBox(height: 16),

                      BlueButton(
                        text: "SIGN UP",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterStep1Page(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
