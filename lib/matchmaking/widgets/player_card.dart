import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/matchmaking/models/player_model.dart';
import 'package:playserve_mobile/matchmaking/screens/matchmaking_service.dart';

class PlayerCard extends StatelessWidget {
  final PlayerModel player;

  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final service = MatchmakingService(request);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFC6DA44),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        // Avatar PNG ada di assets
                        // Path PNG = "assets/image/avatarX.png"
                        // Django kasih SVG path: "image/avatar1.svg"
                        // Jadi kita mapping manual:
                        _mapAvatarToPng(player.avatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.username,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        Text(
                          player.instagram != null &&
                                  player.instagram!.trim().isNotEmpty
                              ? "@${player.instagram}"
                              : "(no instagram)",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final response =
                        await service.createRequest(player.id);

                    final success = response['success'] == true;

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? "Request sent to ${player.username}"
                              : (response['error'] ?? "Request failed"),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC6DA44),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "REQUEST MATCH",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mapping avatar svg Django -> png assets Flutter
  String _mapAvatarToPng(String svgPath) {
    if (svgPath.contains('avatar1')) return 'assets/image/avatar1.png';
    if (svgPath.contains('avatar2')) return 'assets/image/avatar2.png';
    if (svgPath.contains('avatar3')) return 'assets/image/avatar3.png';
    if (svgPath.contains('avatar4')) return 'assets/image/avatar4.png';
    if (svgPath.contains('avatar5')) return 'assets/image/avatar5.png';
    return 'assets/image/avatar1.png';
  }
}
