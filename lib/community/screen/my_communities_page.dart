import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/community.dart';
import 'community_detail_page.dart';
import 'discover_communities_page.dart'; // pastikan file ini ada

class MyCommunitiesPage extends StatefulWidget {
  const MyCommunitiesPage({super.key});

  @override
  State<MyCommunitiesPage> createState() => _MyCommunitiesPageState();
}

class _MyCommunitiesPageState extends State<MyCommunitiesPage> {
  late Future<List<Community>> _myCommunities;

  // Versi Django: subtitle dikirim dari view
  final String _subtitle = 'JOINED';

  // Kalau nanti mau pakai admin logic, bisa diisi dari API
  final bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _myCommunities = _fetchMyCommunities();
  }

  Future<List<Community>> _fetchMyCommunities() async {
    final request = context.read<CookieRequest>();
    final baseUrl =
        kIsWeb ? 'http://127.0.0.1:8000' : 'http://10.0.2.2:8000';

    try {
      final response = await request.get('$baseUrl/community/api/list/');

      if (response != null && response is List) {
        final communities = response
            .map((e) => Community.fromJson(e as Map<String, dynamic>))
            .where((c) => c.isJoined)
            .toList();
        return communities;
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching my communities: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: Stack(
        children: [
          // 🔵 Background image, sama seperti di Discover
          Positioned.fill(
            child: Image.asset(
              'assets/image/bgcommunity.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ============ HERO DI ATAS PANEL ============
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Column(
                    children: [
                      Text(
                        'MY COMMUNITIES',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: kIsWeb ? 40 : 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          height: 1.05,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: kIsWeb ? 18 : 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),

                      if (_isAdmin) ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: implement create community di Flutter kalau mau
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Create Community (to be implemented).'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC1D752),
                            foregroundColor: const Color(0xFF111827),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            '+ Create New Community',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // ============ PANEL / BOX SAMA KAYAK DISCOVER ============
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 16), // sama pattern
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF092B69),
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),

                            // ====== LIST DI DALAM PANEL ======
                            Expanded(
                              child: FutureBuilder<List<Community>>(
                                future: _myCommunities,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Error loading communities.\n${snapshot.error}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }

                                  final communities = snapshot.data ?? [];

                                  if (communities.isEmpty) {
                                    // EMPTY STATE di dalam panel
                                    return Center(
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 24,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 12,
                                              offset: Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.group_outlined,
                                              size: 56,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              "You haven’t joined any communities",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              "Find and join communities that match your interests.",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 24),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const DiscoverCommunitiesPage(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFFC1D752),
                                                foregroundColor:
                                                    const Color(0xFF082459),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 32,
                                                  vertical: 12,
                                                ),
                                                shape:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                elevation: 4,
                                              ),
                                              child: const Text(
                                                "Discover Communities",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return LayoutBuilder(
                                    builder: (context, constraints) {
                                      // 🔹 Phone & tablet: 2 kolom
                                      // 🔹 Desktop lebar: 3 kolom
                                      int crossAxisCount;
                                      if (constraints.maxWidth >= 1024) {
                                        crossAxisCount = 3;
                                      } else {
                                        crossAxisCount = 2;
                                      }

                                      return GridView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: communities.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          childAspectRatio: 0.82, // mirip ukuran card di screenshot kamu
                                        ),
                                        itemBuilder: (context, index) {
                                          final community = communities[index];
                                          return _buildCommunityCard(context, community);
                                        },
                                      );
                                    },
                                  );

                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(BuildContext context, Community community) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Info community
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                community.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${community.membersCount} members',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              if (community.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  community.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // Tombol OPEN COMMUNITY
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommunityDetailPage(
                      communityId: community.id,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC1D752),
                foregroundColor: const Color(0xFF082459),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
              child: const Text(
                'OPEN COMMUNITY',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
