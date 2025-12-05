import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/global_theme.dart';
import 'package:playserve_mobile/authentication/screens/login.dart';

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

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // 🔹 Logo PlayServe
                Image.asset(
                  'assets/image/logo2.png',
                  width: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),

                Text(
                  "Create your account",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),

                // 🧾 Username Field
                RoundedInputField(
                  controller: _usernameController,
                  hintText: "Username",
                  icon: Icons.person,
                  whiteIcon: false,
                ),
                const SizedBox(height: 16),

                // 🔒 Password Field
                RoundedInputField(
                  controller: _passwordController,
                  hintText: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                  whiteIcon: false,
                ),
                const SizedBox(height: 16),

                // ✅ Confirm Password Field
                RoundedInputField(
                  controller: _confirmController,
                  hintText: "Confirm Password",
                  icon: Icons.lock_outline,
                  obscureText: true,
                  whiteIcon: false,
                ),
                const SizedBox(height: 30),

                // 🟩 Tombol Next Step
                _isLoading
                    ? const CircularProgressIndicator(color: limegreen)
                    : LimeButton(
                        text: "NEXT STEP",
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
                                  response["message"] ??
                                      "Registration step 1 failed.",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                const SizedBox(height: 16),

                // 🔵 Back to Login
                BlueButton(
                  text: "BACK TO LOGIN",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                ),
              ],
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
    'Jakarta',
    'Bogor',
    'Depok',
    'Tangerang',
    'Bekasi',
  ];

  String _selectedAvatar = 'image/avatar1.svg';
  String? _selectedLocation;
  final _instagramController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // 🔹 Logo PlayServe
                Image.asset(
                  'assets/image/logo2.png',
                  width: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),

                Text(
                  "Complete Your Profile",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),

                // 🧍 Pilihan Avatar
                Text(
                  "Choose Your Avatar",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: limegreen,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                          color: isSelected ? limegreen : Colors.transparent,
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
                const SizedBox(height: 30),

                // 📍 Dropdown lokasi
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  value: _selectedLocation,
                  decoration: InputDecoration(
                    hintText: "Select Location",
                    hintStyle: const TextStyle(color: greyHint),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: _kotaOptions
                      .map((kota) =>
                          DropdownMenuItem(value: kota, child: Text(kota)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedLocation = val),
                ),
                const SizedBox(height: 16),

                // 📸 Instagram (optional)
                RoundedInputField(
                  controller: _instagramController,
                  hintText: "Instagram (optional)",
                  icon: Icons.camera_alt_outlined,
                  whiteIcon: false,
                ),
                const SizedBox(height: 30),

                // 🟩 Tombol Submit
                _isLoading
                    ? const CircularProgressIndicator(color: limegreen)
                    : LimeButton(
                        text: "LET'S SERVE!",
                        onPressed: () async {
                          if (_selectedLocation == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please select a location.")),
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
                                content:
                                    Text("Welcome, ${response['username']}!"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(response["message"] ??
                                    "Step 2 failed."),
                              ),
                            );
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
