import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/profil/screens/login.dart';

class RegisterStep1Page extends StatefulWidget {
  const RegisterStep1Page({super.key});

  @override
  State<RegisterStep1Page> createState() => _RegisterStep1PageState();
}

class _RegisterStep1PageState extends State<RegisterStep1Page> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFF0C1446),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1446),
        elevation: 0,
        title: const Text("Register - Step 1",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(
                          color: Color(0xFF0C1446),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB8D243),
                              foregroundColor: const Color(0xFF0C1446),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: () async {
                              final username = _usernameController.text.trim();
                              final password1 = _passwordController.text.trim();
                              final password2 = _confirmController.text.trim();

                              if (username.isEmpty ||
                                  password1.isEmpty ||
                                  password2.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("All fields must be filled.")),
                                );
                                return;
                              }

                              setState(() => _isLoading = true);

                              final response = await request.postJson(
                                "http://127.0.0.1:8000/auth/register/step1/",
                                jsonEncode({
                                  "username": username,
                                  "password1": password1,
                                  "password2": password2,
                                }),
                              );

                              setState(() => _isLoading = false);

                              if (response["status"] == "success") {
                                if (!mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        RegisterStep2Page(username: username),
                                  ),
                                );
                              } else {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        response["message"] ?? "Registration step 1 failed."),
                                  ),
                                );
                              }
                            },
                            child: const Text("Next Step"),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterStep2Page extends StatefulWidget {
  final String username;
  const RegisterStep2Page({super.key, required this.username});

  @override
  State<RegisterStep2Page> createState() => _RegisterStep2PageState();
}

class _RegisterStep2PageState extends State<RegisterStep2Page> {
  final List<Map<String, String>> _avatarOptions = const [
    {"png": "assets/image/avatar1.png", "svg": "image/avatar1.svg"},
    {"png": "assets/image/avatar2.png", "svg": "image/avatar2.svg"},
    {"png": "assets/image/avatar3.png", "svg": "image/avatar3.svg"},
    {"png": "assets/image/avatar4.png", "svg": "image/avatar4.svg"},
    {"png": "assets/image/avatar5.png", "svg": "image/avatar5.svg"},
  ];

  final List<String> _kotaOptions = const [
    'Jakarta', 'Bogor', 'Depok', 'Tangerang', 'Bekasi',
  ];

  String _selectedAvatar = 'image/avatar1.svg';
  String? _selectedLocation;
  final _instagramController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFF0C1446),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1446),
        elevation: 0,
        title: const Text("Register - Step 2",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "YOUR PROFILE",
                      style: TextStyle(
                          color: Color(0xFF0C1446),
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Choose your avatar and set your location.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Choose Your Avatar",
                      style: TextStyle(
                          color: Color(0xFFB8D243),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: _avatarOptions.map((avatar) {
                        final isSelected = _selectedAvatar == avatar["svg"];
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedAvatar = avatar["svg"]!),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFB8D243)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(avatar["png"]!),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      decoration: InputDecoration(
                        labelText: "Location",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      items: _kotaOptions
                          .map((kota) => DropdownMenuItem(
                                value: kota,
                                child: Text(kota),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedLocation = val),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _instagramController,
                      decoration: InputDecoration(
                        labelText: "Instagram (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator(
                            color: Color(0xFFB8D243))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB8D243),
                              foregroundColor: const Color(0xFF0C1446),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: () async {
                              if (_selectedLocation == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please select a location.")),
                                );
                                return;
                              }

                              setState(() => _isLoading = true);
                              final response = await request.postJson(
                                "http://127.0.0.1:8000/auth/register/step2/",
                                jsonEncode({
                                  "username": widget.username,
                                  "lokasi": _selectedLocation!,
                                  "instagram":
                                      _instagramController.text.trim(),
                                  "avatar": _selectedAvatar,
                                }),
                              );
                              setState(() => _isLoading = false);

                              if (!mounted) return;
                              if (response["status"] == "success") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Welcome, ${response['username']}!")),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginPage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          response["message"] ?? "Step 2 failed.")),
                                );
                              }
                            },
                            child: const Text("LET'S SERVE!"),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}