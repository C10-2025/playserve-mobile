import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/community.dart';
import '../widgets/community_card.dart';
import 'community_detail_page.dart';

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

  String get _baseUrl =>
      kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';

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
      final result = await request.postJson(joinUrl, jsonEncode({}));

      if (!mounted) return;

      final snackBar = SnackBar(
        content: Text(
          result['status'] == 'joined'
              ? 'You have joined ${result['community_name']}.'
              : 'Already a member of ${result['community_name']}.',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      await _refresh();
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
      backgroundColor: const Color(0xFF082459),
      appBar: AppBar(
        backgroundColor: const Color(0xFF082459),
        elevation: 0,
        title: const Text(
          'Discover Communities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // “Find Your Community” + search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  const Text(
                    'Find Your Community',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search for a community...',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {
                      _searchQuery = value;
                      _refresh();
                    },
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF092B69),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CommunityDetailPage(communityId: c.id),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
