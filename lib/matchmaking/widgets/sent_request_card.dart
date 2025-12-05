import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:playserve_mobile/matchmaking/models/incoming_request_model.dart';
import 'package:playserve_mobile/matchmaking/screens/matchmaking_service.dart';
import 'package:playserve_mobile/matchmaking/screens/active_session_page.dart';

class SentRequestCard extends StatelessWidget {
  final IncomingRequestModel req;
  final VoidCallback onRemove;
  final VoidCallback onRefreshRequested;

  const SentRequestCard({
    super.key,
    required this.req,
    required this.onRemove,
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
                        _mapAvatarToPng(req.senderAvatar),
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
                          req.senderUsername,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          req.senderInstagram != null &&
                                  req.senderInstagram.toString().trim().isNotEmpty
                              ? "@${req.senderInstagram}"
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

              Row(
                children: [

                  // ACCEPT BUTTON
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final response = await service.handleRequest(
                          req.requestId,
                          "ACCEPT",
                        );

                        if (!context.mounted) return;

                        if (response['success'] != true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response['error'] ?? "Failed to accept")),
                          );
                          return;
                        }

                        final activeJson = await service.getActiveSession();

                        if (activeJson['has_session'] == true && context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const ActiveSessionPage()),
                          );
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
                        "ACCEPT",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // REJECT BUTTON
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final response = await service.handleRequest(
                          req.requestId,
                          "REJECT",
                        );

                        if (!context.mounted) return;

                        final success = response['success'] == true;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                            success ? "Request rejected" : "Failed to reject",
                          )),
                        );

                        if (success) {
                          onRemove();
                          onRefreshRequested();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001946),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "REJECT",
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
            ],
          ),
        ),
      ),
    );
  }

  String _mapAvatarToPng(String avatar) {
    if (avatar.contains("avatar1")) return "assets/image/avatar1.png";
    if (avatar.contains("avatar2")) return "assets/image/avatar2.png";
    if (avatar.contains("avatar3")) return "assets/image/avatar3.png";
    if (avatar.contains("avatar4")) return "assets/image/avatar4.png";
    if (avatar.contains("avatar5")) return "assets/image/avatar5.png";
    return "assets/image/avatar1.png";
  }
}
