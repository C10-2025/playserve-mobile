import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
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
        "http://127.0.0.1:8000/matchmaking/api/active-session/",
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
        "http://127.0.0.1:8000/matchmaking/api/opponent/$oppId/",
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
      "http://127.0.0.1:8000/matchmaking/action/finish-session/",
      jsonEncode({
        "session_id": sessionJson!["session_id"],
        "action": action,
      }),
    );

    if (!mounted) return;

    if (result["success"] == true) {
      Navigator.pop(context);
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

  // Map avatar SVG -> PNG asset
  String _avatarToPng(String svg) {
    if (svg.contains("avatar1")) return "assets/image/avatar1.png";
    if (svg.contains("avatar2")) return "assets/image/avatar2.png";
    if (svg.contains("avatar3")) return "assets/image/avatar3.png";
    if (svg.contains("avatar4")) return "assets/image/avatar4.png";
    if (svg.contains("avatar5")) return "assets/image/avatar5.png";
    return "assets/image/avatar1.png";
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
            // Avatar ----------------------------------------------------
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFFC6DA44),
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

            const SizedBox(height: 16),

            // Username ---------------------------------------------------
            Text(
              player.username,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF001946),
              ),
            ),

            Text(
              player.instagram != null && player.instagram!.isNotEmpty
                  ? "@${player.instagram}"
                  : "(no instagram)",
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 24),

            // Buttons ----------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onWin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC6DA44),
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
                      backgroundColor: Color(0xFF001946),
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
                  side: BorderSide(color: Color(0xFFC6DA44), width: 2),
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
                    color: Color(0xFFC6DA44),
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
