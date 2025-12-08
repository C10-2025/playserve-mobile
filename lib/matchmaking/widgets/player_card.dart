import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/matchmaking/widgets/clickable_instagram_text.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/matchmaking/models/player_model.dart';
import 'package:playserve_mobile/matchmaking/screens/matchmaking_service.dart';

class PlayerCard extends StatelessWidget {
  final PlayerModel player;
  final VoidCallback onRequestSent;
  final VoidCallback onRefreshRequested;

  const PlayerCard({
    super.key,
    required this.player,
    required this.onRequestSent,
    required this.onRefreshRequested,
  });

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Avatar + badge
                  Stack(
                    clipBehavior: Clip.none,
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
                            _mapAvatarToPng(player.avatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Image.asset(
                          _mapRankToBadge(player.rank),
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ],
                  ),

                  // SPACING DIBESARKAN
                  const SizedBox(width: 20),

                  // User info dengan padding ekstra
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player.username,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF082459),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 2),

                          ClickableInstagramText(username: player.instagram),
                        ],
                      ),
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 16),

              // ---------- BUTTON ----------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final response = await service.createRequest(player.id);
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

                    if (success) {
                      onRequestSent();
                      onRefreshRequested();
                    }
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

  // ---------- AVATAR PNG ----------
  String _mapAvatarToPng(String svgPath) {
    if (svgPath.contains('avatar1')) return 'assets/image/avatar1.png';
    if (svgPath.contains('avatar2')) return 'assets/image/avatar2.png';
    if (svgPath.contains('avatar3')) return 'assets/image/avatar3.png';
    if (svgPath.contains('avatar4')) return 'assets/image/avatar4.png';
    if (svgPath.contains('avatar5')) return 'assets/image/avatar5.png';
    return 'assets/image/avatar1.png';
  }

  // ---------- BADGE PNG ----------
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
}
