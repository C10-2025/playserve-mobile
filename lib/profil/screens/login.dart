import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/profil/screens/menu.dart'; // TODO: use this when that module is done
import 'package:playserve_mobile/profil/screens/register.dart';
import 'package:playserve_mobile/review/screens/review_page.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFF0C1446),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            color: Colors.white,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C1446),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 40),

                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Color(0xFF0C1446)),
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Color(0xFF0C1446)),
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  _isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFFB8D243),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            String username = _usernameController.text.trim();
                            String password = _passwordController.text.trim();

                            if (username.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill in all fields."),
                                ),
                              );
                              return;
                            }

                            setState(() => _isLoading = true);

                            final response = await request.login(
                              "http://127.0.0.1:8000/auth/login/",
                              {'username': username, 'password': password},
                            );

                            setState(() => _isLoading = false);

                            if (request.loggedIn) {
                              String message =
                                  response['message'] ?? 'Login success!';
                              String uname = response['username'] ?? username;

                              // Admin?
                              bool isAdmin = response["is_admin"] ?? false;
                              request.jsonData["is_admin"] = isAdmin;

                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    // TODO: Replace this with MyHomePage() when that module is done
                                    builder: (context) => const ReviewPage(),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFFB8D243),
                                      content: Text(
                                        "$message Welcome, $uname.",
                                        style: const TextStyle(
                                          color: Color(0xFF0C1446),
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
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    title: const Text(
                                      'Login Failed',
                                      style: TextStyle(
                                        color: Color(0xFF0C1446),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      response['message'] ??
                                          'Invalid username or password.',
                                      style: const TextStyle(
                                        color: Color(0xFF0C1446),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            color: Color(0xFFB8D243),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB8D243),
                            foregroundColor: const Color(0xFF0C1446),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 55),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          child: const Text('LOGIN'),
                        ),
                  const SizedBox(height: 12.0),
                  const SizedBox(height: 36.0),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterStep1Page(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        color: Color(0xFFB8D243),
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
