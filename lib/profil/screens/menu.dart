import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/booking/screens/field_list_screen.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFF0C1446),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1446),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "PlayServe Home",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to PlayServe!",
                style: TextStyle(
                  color: Color(0xFFB8D243),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "You are now logged in successfully.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.sports_tennis, color: Color(0xFFB8D243)),
                  label: const Text(
                    "Go to Booking",
                    style: TextStyle(
                      color: Color(0xFFB8D243),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FieldListScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFB8D243)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol logout
              ElevatedButton(
                onPressed: () async {
                  await request.logout("http://localhost:8000/auth/logout");
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You have been logged out."),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8D243),
                  foregroundColor: const Color(0xFF0C1446),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                child: const Text("LOGOUT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
