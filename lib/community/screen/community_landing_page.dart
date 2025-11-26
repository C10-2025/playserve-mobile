import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/community.dart';
import 'package:flutter/foundation.dart';

class CommunityLandingPage extends StatefulWidget {
  const CommunityLandingPage({super.key});

  @override
  State<CommunityLandingPage> createState() => _CommunityLandingPageState();
}

class _CommunityLandingPageState extends State<CommunityLandingPage> {
  late Future<List<Community>> _futureCommunities;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureCommunities = _fetchCommunities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Community>> _fetchCommunities() async {
    final request = context.read<CookieRequest>();
    final baseUrl = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';
    
    try {
      final response = await request.get(
        '$baseUrl/community/api/list/?q=${Uri.encodeQueryComponent(_searchQuery)}'
      );
      
      if (response != null && response is List) {
        return response.map((e) => Community.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching: $e');
      return [];
    }
  }

  Future<void> _joinCommunity(Community community) async {
    final request = context.read<CookieRequest>();
    final baseUrl = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';
    
    try {
      final response = await request.post(
        '$baseUrl/community/join/${community.id}/',
        {}
      );
      
      if (response != null && response['status'] == 'joined') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Successfully joined ${community.name}!"),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _futureCommunities = _fetchCommunities();
          });
        }
      } else if (response != null && response['status'] == 'already_joined') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("You're already a member of ${community.name}"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please login first to join community"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _search() {
    setState(() {
      _searchQuery = _searchController.text;
      _futureCommunities = _fetchCommunities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff082459),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "FIND YOUR COMMUNITY",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/my-communities');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFFEB3B),
                      foregroundColor: const Color(0xff082459),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "SEE MY COMMUNITIES",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Discover Section
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff092B69).withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  const Text(
                    "Discover Communities",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (_) => _search(),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search for a community...",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.grey),
                          onPressed: _search,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Communities List
                  FutureBuilder<List<Community>>(
                    future: _futureCommunities,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      final communities = snapshot.data ?? [];

                      if (communities.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            "No communities found.",
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: communities.length,
                        itemBuilder: (context, index) {
                          final community = communities[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  community.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${community.membersCount} members",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                if (community.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    community.description,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: community.isJoined
                                        ? null
                                        : () => _joinCommunity(community),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: community.isJoined
                                          ? Colors.grey[400]
                                          : const Color(0xff4CAF50),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      disabledBackgroundColor: Colors.grey[400],
                                    ),
                                    child: Text(
                                      community.isJoined ? "JOINED" : "JOIN NOW",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}