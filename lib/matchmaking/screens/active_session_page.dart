import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/matchmaking/screens/dashboard_page.dart';
import 'package:playserve_mobile/matchmaking/widgets/clickable_instagram_text.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/matchmaking/models/player_model.dart';

class ActiveSessionPage extends StatefulWidget {
  const ActiveSessionPage({super.key});

  @override
  State<ActiveSessionPage> createState() => _ActiveSessionPageState();
}

class _ActiveSessionPageState extends State<ActiveSessionPage> {
  bool isLoading = true;

  Map<String, dynamic>? sessionJson;
  PlayerModel? opponent;

  @override
  void initState() {
    super.initState();
    loadActiveSession();
  }

  Future<void> loadActiveSession() async {
    final request = context.read<CookieRequest>();

    try {
      // Fetch active session info
      final res = await request.get(
        "https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id/matchmaking/api/active-session/",
      );

      if (res["has_session"] != true) {
        if (!mounted) return;
        Navigator.pop(context); // No match active
        return;
      }

      sessionJson = res;

      // Tentukan ID opponent
      final oppId = res["you_are_player1"]
          ? res["player2"]["id"]
          : res["player1"]["id"];

      // Fetch profil lengkap opponent
      final oppJson = await request.get(
        "https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id/matchmaking/api/opponent/$oppId/",
      );

      opponent = PlayerModel.fromJson(oppJson);
    } catch (e) {
      print("ACTIVE SESSION ERROR: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> finishMatch(String action) async {
    final request = context.read<CookieRequest>();

    final result = await request.postJson(
      "https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id/matchmaking/action/finish-session/",
      jsonEncode({
        "session_id": int.parse(sessionJson!["session_id"].toString()),
        "action": action,
      }),
    );

    if (!mounted) return;

    if (result["success"] == true) {
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Match updated.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${result['error']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || opponent == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF042A76),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF042A76),
              Color(0xFF0A4AA3),
            ],
          ),
        ),

        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/image/bg_pattern.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Text(
                    "DID YOU WIN THE\nMATCH WITH",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: Center(
                      child: _OpponentCard(
                        player: opponent!,
                        onWin: () => finishMatch("WIN"),
                        onLose: () => finishMatch("LOSE"),
                        onCancel: () => finishMatch("CANCEL"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpponentCard extends StatelessWidget {
  final PlayerModel player;
  final VoidCallback onWin;
  final VoidCallback onLose;
  final VoidCallback onCancel;

  const _OpponentCard({
    required this.player,
    required this.onWin,
    required this.onLose,
    required this.onCancel,
  });

  String _avatarToPng(String svg) {
    if (svg.contains("avatar1")) return "assets/image/avatar1.png";
    if (svg.contains("avatar2")) return "assets/image/avatar2.png";
    if (svg.contains("avatar3")) return "assets/image/avatar3.png";
    if (svg.contains("avatar4")) return "assets/image/avatar4.png";
    if (svg.contains("avatar5")) return "assets/image/avatar5.png";
    return "assets/image/avatar1.png";
  }

  String _mapRankToBadge(String rank) {
    switch (rank.toLowerCase()) {
      case "bronze":
        return "assets/image/bronze.png";
      case "silver":
        return "assets/image/silver.png";
      case "gold":
        return "assets/image/gold.png";
      case "platinum":
        return "assets/image/platinum.png";
      case "diamond":
        return "assets/image/diamond.png";
      default:
        return "assets/image/bronze.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ---------------- AVATAR + BADGE ----------------
            Stack(
              clipBehavior: Clip.none,     // <<< FIX PENTING
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFC6DA44),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      _avatarToPng(player.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  right: -6,
                  bottom: -6,
                  child: Image.asset(
                    _mapRankToBadge(player.rank),
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Username
            Text(
              player.username,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF082459),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            ClickableInstagramText(
              username: player.instagram,
            ),

            const SizedBox(height: 28),

            // ---------------- Buttons ----------------
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onWin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC6DA44),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "WIN",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: onLose,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001946),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "LOSE",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFC6DA44), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "CANCEL",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC6DA44),
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
