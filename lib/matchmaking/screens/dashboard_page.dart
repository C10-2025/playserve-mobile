import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:playserve_mobile/matchmaking/widgets/filter_button.dart';
import 'package:playserve_mobile/matchmaking/widgets/player_card.dart';
import 'package:playserve_mobile/matchmaking/widgets/sent_request_card.dart';

import 'package:playserve_mobile/matchmaking/screens/matchmaking_service.dart';
import 'package:playserve_mobile/matchmaking/models/player_model.dart';
import 'package:playserve_mobile/matchmaking/models/incoming_request_model.dart';
import 'package:playserve_mobile/matchmaking/models/match_session_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isTopPicks = true;

  bool isLoading = true;
  List<PlayerModel> availablePlayers = [];
  List<IncomingRequestModel> incomingRequests = [];

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    final request = context.read<CookieRequest>();
    final service = MatchmakingService(request);

    setState(() {
      isLoading = true;
    });

    // Fetch data dari Django
    final availableJson = await service.getAvailableUsers();
    final incomingJson = await service.getIncomingRequests();

    setState(() {
      availablePlayers = availableJson.map((u) => PlayerModel.fromJson(u)).toList();
      incomingRequests = incomingJson.map((r) => IncomingRequestModel.fromJson(r)).toList();
      isLoading = false;
    });

    // Check active match session
    final active = await service.getActiveSession();
    final session = MatchSessionModel.fromJson(active);

    if (session.hasSession == true && mounted) {
      // TODO: Redirect ke ActiveMatchPage() nanti
      // Navigator.push(context, MaterialPageRoute(builder: (_) => ActiveMatchPage(session: session)));
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    Text(
                      "FIND A MATCH",
                      style: GoogleFonts.inter(
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Filter buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilterButton(
                          text: "TOP PICKS\nFOR YOU",
                          isActive: isTopPicks,
                          onTap: () {
                            setState(() {
                              isTopPicks = true;
                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        FilterButton(
                          text: "SENT\nREQUESTS",
                          isActive: !isTopPicks,
                          onTap: () {
                            setState(() {
                              isTopPicks = false;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: fetchAllData,
                              child: ListView(
                                children: [
                                  if (isTopPicks) ...[
                                    if (availablePlayers.isEmpty)
                                      _emptyMessage("No players available")
                                    else
                                      ...availablePlayers.map((p) => Padding(
                                            padding: const EdgeInsets.only(bottom: 20),
                                            child: PlayerCard(player: p),
                                          )),
                                  ] else ...[
                                    if (incomingRequests.isEmpty)
                                      _emptyMessage("No incoming requests")
                                    else
                                      ...incomingRequests.map((r) => Padding(
                                            padding: const EdgeInsets.only(bottom: 20),
                                            child: SentRequestCard(req: r),
                                          )),
                                  ],
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pesan ketika list kosong
  Widget _emptyMessage(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
