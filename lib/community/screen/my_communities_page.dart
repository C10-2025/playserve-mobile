import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/community.dart';
import 'community_detail_page.dart';
import 'discover_communities_page.dart';
import 'package:playserve_mobile/main_navbar.dart';
import 'package:playserve_mobile/main_navbar_admin.dart'; 
import 'package:playserve_mobile/header.dart';

class MyCommunitiesPage extends StatefulWidget {
  const MyCommunitiesPage({super.key});

  @override
  State<MyCommunitiesPage> createState() => _MyCommunitiesPageState();
}

class _MyCommunitiesPageState extends State<MyCommunitiesPage> {
  late Future<List<Community>> _myCommunities;

  final TextEditingController _createNameController = TextEditingController();
  final TextEditingController _createDescController = TextEditingController();

  final String _subtitle = 'JOINED';

  static const String apiBase = 'https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id';
  String get _baseUrl => apiBase;

  bool get _isAdminFlag {
  final request = context.read<CookieRequest>();
  return request.jsonData["is_admin"] == true;
}



  @override
  void initState() {
    super.initState();
    _myCommunities = _fetchMyCommunities();

  }

  Widget _buildBottomNav() {
    return _isAdminFlag
        ? const MainNavbarAdmin(currentIndex: 4) 
        : const MainNavbar(currentIndex: 1);
  }

  @override
  void dispose() {
    _createNameController.dispose();
    _createDescController.dispose();
    super.dispose();
  }

  Future<List<Community>> _fetchMyCommunities() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('$_baseUrl/community/api/list/');
      if (response is List) {
        return response
            .map((e) => Community.fromJson(e as Map<String, dynamic>))
            .where((c) => c.isJoined)
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching my communities: $e');
      return [];
    }
  }

  Future<void> _refreshMyCommunities() async {
    setState(() {
      _myCommunities = _fetchMyCommunities();
    });
    await _myCommunities;
  }

  void _openCreateCommunityDialog() {
    _createNameController.clear();
    _createDescController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            Future<void> handleSubmit() async {
              final name = _createNameController.text.trim();
              final desc = _createDescController.text.trim();

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name is required.')),
                );
                return;
              }

              setStateDialog(() => isSubmitting = true);

              final request = context.read<CookieRequest>();
              final url = '$_baseUrl/community/create/';

              try {
                final resp = await request.postJson(
                  url,
                  jsonEncode({'name': name, 'description': desc}),
                );

                if (!mounted) return;

                if (resp is Map) {
                  final code = resp['code'];
                  final message = resp['message'] as String? ??
                      'Community created successfully.';

                  if (code == 'duplicate_name') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Community name already exists. Please use a different name.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    setStateDialog(() => isSubmitting = false);
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: const Color(0xFFC1D752),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Community created.')),
                  );
                }

                Navigator.of(ctx).pop();
                await _refreshMyCommunities();
              } catch (_) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to create community.'),
                    backgroundColor: Colors.red,
                  ),
                );
                setStateDialog(() => isSubmitting = false);
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Create New Community',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: const Color(0xFF111827),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Name',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _createNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter community name',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF9CA3AF),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Description',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _createDescController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Describe the community...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF9CA3AF),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.width < 420 ? 38 : 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1D5DB),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextButton(
                          onPressed:
                              isSubmitting ? null : () => Navigator.pop(ctx),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.width < 420 ? 38 : 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC1D752),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextButton(
                          onPressed: isSubmitting ? null : handleSubmit,
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Create',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHero(String subtitleText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        children: [
          Text(
            'MY COMMUNITIES',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: kIsWeb ? 40 : 30,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              height: 1.05,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitleText,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: kIsWeb ? 18 : 16,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          if (_isAdminFlag) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: MediaQuery.of(context).size.width < 420 ? 38 : 46,
              child: ElevatedButton(
                onPressed: _openCreateCommunityDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC1D752),
                  foregroundColor: const Color(0xFF082459),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                child: const Text('+ CREATE COMMUNITY'),
              ),
            ),
          ],
        ],
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    final isAdmin = _isAdminFlag; 
    final subtitleText = _isAdminFlag ? 'CREATED BY ME' : _subtitle;

    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      bottomNavigationBar: _buildBottomNav(), 
      body: Stack(
        children: [
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
                if (!isAdmin) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: ProfileHeader(),
                  ),
                  const SizedBox(height: 12),
                ],
                Flexible(
                  flex: 0,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: _buildHero(subtitleText),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF092B69),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
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
                                  style: GoogleFonts.inter(color: Colors.white),
                                ),
                              );
                            }

                            final communities = snapshot.data ?? [];

                            if (communities.isEmpty) {
                              return Center(
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
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
                                      Text(
                                        "You haven’t joined any communities",
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Find and join communities that match your interests.",
                                        style: GoogleFonts.inter(
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
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 4,
                                        ),
                                        child: Text(
                                          "Discover Communities",
                                          style: GoogleFonts.inter(
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
                                int crossAxisCount;
                                if (constraints.maxWidth >= 1024) {
                                  crossAxisCount = 3;
                                } else {
                                  crossAxisCount = 2;
                                }

                                return RefreshIndicator(
                                  onRefresh: _refreshMyCommunities,
                                  child: GridView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: communities.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 0.82,
                                    ),
                                    itemBuilder: (context, index) {
                                      final community = communities[index];
                                      return _buildCommunityCard(
                                        context,
                                        community,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                community.name,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${community.membersCount} members',
                style: GoogleFonts.inter(
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
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
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
              child: Text(
                'OPEN COMMUNITY',
                style: GoogleFonts.inter(
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