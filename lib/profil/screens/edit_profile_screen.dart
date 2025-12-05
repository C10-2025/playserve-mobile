import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playserve_mobile/global_theme.dart';
import 'package:playserve_mobile/authentication/screens/login.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _instagramController = TextEditingController();
  String? _selectedLocation;
  String _selectedAvatar = "image/avatar1.svg";
  bool _isLoading = false;
  bool _isLoggingOut = false;
  bool _showAvatarOptions = false;

  final List<Map<String, String>> _avatarOptions = const [
    {"png": "assets/image/avatar1.png", "svg": "image/avatar1.svg"},
    {"png": "assets/image/avatar2.png", "svg": "image/avatar2.svg"},
    {"png": "assets/image/avatar3.png", "svg": "image/avatar3.svg"},
    {"png": "assets/image/avatar4.png", "svg": "image/avatar4.svg"},
    {"png": "assets/image/avatar5.png", "svg": "image/avatar5.svg"},
  ];

  final List<String> _locationOptions = const [
    "Jakarta",
    "Bogor",
    "Depok",
    "Tangerang",
    "Bekasi",
  ];

  String _username = "@username";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.get("http://127.0.0.1:8000/auth/get_user/");

      if (response["status"] == true) {
        setState(() {
          _username = response["username"];
          _instagramController.text = response["instagram"] ?? "";
          _selectedLocation = response["lokasi"] ?? "Jakarta";
          _selectedAvatar = response["avatar"] ?? "image/avatar1.svg";
        });

        // 🔹 Simpan ke SharedPreferences (cache)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', response["username"]);
        await prefs.setString('instagram', response["instagram"] ?? "");
        await prefs.setString('lokasi', response["lokasi"] ?? "");
        await prefs.setString('avatar', response["avatar"] ?? "");
        await prefs.setString('rank', response["rank"] ?? "");
      }
    } catch (e) {
      debugPrint("Failed to fetch user profile: $e");
    }
  }


  Future<void> _saveProfile(CookieRequest request) async {
    setState(() => _isLoading = true);

    final response = await request.postJson(
      'http://127.0.0.1:8000/auth/edit_profile/',
      jsonEncode({
        "instagram": _instagramController.text.trim(),
        "lokasi": _selectedLocation,
        "avatar": _selectedAvatar,
      }),
    );

    setState(() => _isLoading = false);

    if (response["status"] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('instagram', response["instagram"]);
      await prefs.setString('lokasi', response["lokasi"]);
      await prefs.setString('avatar', response["avatar"]);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(response["message"]),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(response["message"] ?? "Failed to save profile."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    final userData = request.jsonData;
    final username = userData['username'] ?? _username;
    final avatarPath = _getAvatarPngPath(_selectedAvatar);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "EDIT MY PROFILE",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 6,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(avatarPath),
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showAvatarOptions = !_showAvatarOptions;
                        });
                      },
                      child: Text(
                        "Change Avatar",
                        style: GoogleFonts.inter(
                          color: limegreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (_showAvatarOptions) _buildAvatarPicker(),

                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: GoogleFonts.inter(
                        color: blue1,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Instagram Field
                    TextField(
                      controller: _instagramController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Instagram",
                        hintText: "@yourhandle",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: GoogleFonts.inter(color: blue1),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      decoration: InputDecoration(
                        labelText: "Location",
                        labelStyle: GoogleFonts.inter(color: blue1),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _locationOptions
                          .map((loc) => DropdownMenuItem(
                                value: loc,
                                child: Text(loc),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() {
                        _selectedLocation = val;
                      }),
                    ),

                    const SizedBox(height: 28),

                    // Save Button
                    _isLoading
                        ? const CircularProgressIndicator(color: Color(0xFFB8D243))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: limegreen,
                              foregroundColor: blue1,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () async => _saveProfile(request),
                            child: const Text("SAVE CHANGES"),
                          ),
                    const SizedBox(height: 16),

                    // Logout Button
                    _isLoggingOut
                        ? const CircularProgressIndicator(color: blue1)
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue1,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () async {
                              setState(() => _isLoggingOut = true);
                              await request
                                  .get('http://127.0.0.1:8000/auth/logout/');
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginPage()),
                                  (route) => false,
                                );
                              }
                            },
                            child: const Text("LOGOUT"),
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

  Widget _buildAvatarPicker() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: _avatarOptions.map((avatar) {
          final isSelected = _selectedAvatar == avatar["svg"];
          return GestureDetector(
            onTap: () {
              setState(() => _selectedAvatar = avatar["svg"]!);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? limegreen.withOpacity(0.5) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(avatar["png"]!),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getAvatarPngPath(String svgPath) {
    return _avatarOptions
        .firstWhere(
          (a) => a["svg"] == svgPath,
          orElse: () => _avatarOptions.first,
        )["png"]!;
  }
}