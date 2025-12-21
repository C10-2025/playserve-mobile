import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playserve_mobile/profil/screens/edit_profile_screen.dart';
import 'package:playserve_mobile/global_theme.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String username = "";
  String rank = "BRONZE";
  String avatar = "image/avatar1.svg";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.get(
        "http://127.0.0.1:8000/auth/get_user/",
      );

      if (response["status"] == true) {
        setState(() {
          username = response["username"] ?? "";
          rank = response["rank"] ?? "BRONZE";
          avatar = response["avatar"] ?? "image/avatar1.svg";
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("username", username);
        await prefs.setString("rank", rank);
        await prefs.setString("avatar", avatar);
      } else {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          username = prefs.getString("username") ?? "";
          rank = prefs.getString("rank") ?? "BRONZE";
          avatar = prefs.getString("avatar") ?? "image/avatar1.svg";
        });
      }
    } catch (e) {
      debugPrint("Failed to load user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            );

            if (result == true) {
              _loadUserData();
            }
          },
          child: CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage(_getAvatarPngPath(avatar)),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              rank.toUpperCase(),
              style: GoogleFonts.inter(
                color: limegreen,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getAvatarPngPath(String svgPath) {
    final avatarMap = {
      "image/avatar1.svg": "assets/image/avatar1.png",
      "image/avatar2.svg": "assets/image/avatar2.png",
      "image/avatar3.svg": "assets/image/avatar3.png",
      "image/avatar4.svg": "assets/image/avatar4.png",
      "image/avatar5.svg": "assets/image/avatar5.png",
    };
    return avatarMap[svgPath] ?? "assets/image/avatar1.png";
  }
}
