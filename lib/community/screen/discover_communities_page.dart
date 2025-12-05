import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/community.dart';
import '../widgets/community_card.dart';
import 'community_detail_page.dart';
import 'my_communities_page.dart';


class DiscoverCommunitiesPage extends StatefulWidget {
  const DiscoverCommunitiesPage({super.key});

  @override
  State<DiscoverCommunitiesPage> createState() =>
      _DiscoverCommunitiesPageState();
}

class _DiscoverCommunitiesPageState extends State<DiscoverCommunitiesPage> {
  late Future<List<Community>> _futureCommunities;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // PENTING: samakan host dengan URL yang dipakai di login (biasanya 127.0.0.1)
  String get _baseUrl =>
      kIsWeb ? 'http://127.0.0.1:8000' : 'http://10.0.2.2:8000';

  @override
  void initState() {
    super.initState();
    _futureCommunities = _fetchCommunities();
  }

  Future<List<Community>> _fetchCommunities() async {
    final request = context.read<CookieRequest>();

    final url =
        '$_baseUrl/community/api/list/?q=${Uri.encodeQueryComponent(_searchQuery)}';

    final response = await request.get(url);
    final list = response as List<dynamic>;

    return list
        .map((raw) => Community.fromJson(raw as Map<String, dynamic>))
        .toList();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureCommunities = _fetchCommunities();
    });
  }

  Future<void> _joinCommunity(Community community) async {
    final request = context.read<CookieRequest>();
    final joinUrl = '$_baseUrl/community/join/${community.id}/';

    try {
      // CookieRequest akan otomatis kirim session + csrftoken
      final result = await request.postJson(joinUrl, jsonEncode({}));

      if (!mounted) return;

      if (result is Map && result['status'] != null) {
        final status = result['status'] as String;
        final name = result['community_name'] ?? community.name;

        final snackBar = SnackBar(
          content: Text(
            status == 'joined'
                ? 'You have joined $name.'
                : 'Already a member of $name.',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        await _refresh();
      } else {
        // fallback kalau response bukan JSON yang diharapkan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unexpected response from server.'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to join community. Please try again.'),
        ),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
  backgroundColor: const Color(0xFF1E3A8A), // Tailwind blue-900

    body: Stack(
      children: [
        // 🔵 Background hero
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
              // ====== HERO: FIND YOUR COMMUNITY + BUTTON ======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                    'FIND YOUR COMMUNITY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: kIsWeb ? 42 : 30, // bigger = bolder impression
                      fontWeight: FontWeight.w900, // strongest weight
                      color: Colors.white,
                      letterSpacing: 2.0, // increases bold visual
                      height: 1.05,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 0),
                          blurRadius: 1.8,
                          color: Colors.white.withOpacity(0.35),
                        ),
                      ],
                    ),
                  ),

                    const SizedBox(height: 16),

                    // 🔘 SEE MY COMMUNITIES (center, tidak full width)
                    Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 180,
                          maxWidth: 260,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MyCommunitiesPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC1D752),
                            foregroundColor: const Color(0xFF082459),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                          child: const Text('SEE MY COMMUNITIES'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF092B69),
                      borderRadius: BorderRadius.all(
                        Radius.circular(24), // rounded semua sisi, kayak card
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
                          // 🏷 TITLE DALAM PANEL
                          const Text(
                            'Discover Communities',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 🔍 SEARCH BAR: center + width dibatasi
                          Align(
                            alignment: Alignment.center,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: kIsWeb ? 600 : 320, // web lebar, mobile lebih sempit
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search for a community...',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Image.asset(
                                      'assets/image/search.png',
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(999),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(999),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(999),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onSubmitted: (value) {
                                  _searchQuery = value;
                                  _refresh();
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // GRID DI BAWAH SEARCH
                          Expanded(
                            child: FutureBuilder<List<Community>>(
                              future: _futureCommunities,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error loading communities.\n${snapshot.error}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }

                                final communities = snapshot.data ?? [];

                                if (communities.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'No communities found.',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  );
                                }

                                return RefreshIndicator(
                                  onRefresh: _refresh,
                                  child: GridView.builder(
                                    itemCount: communities.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 0.82,
                                    ),
                                    itemBuilder: (context, index) {
                                      final c = communities[index];
                                      return CommunityCard(
                                        community: c,
                                        onTap: () {
                                          if (!c.isJoined) {
                                            // Hanya info kecil, tidak navigate
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Join this community first to see its posts.'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                            return;
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CommunityDetailPage(
                                                communityId: c.id,
                                              ),
                                            ),
                                          );
                                        },
                                        onJoin: () => _joinCommunity(c),
                                      );

                                    },
                                  ),
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
}