import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/community.dart';
import '../widgets/community_card.dart';
import 'community_detail_page.dart';
import 'my_communities_page.dart';

import 'package:playserve_mobile/main_navbar.dart';
import 'package:playserve_mobile/main_navbar_admin.dart';

import 'package:playserve_mobile/header.dart';

class DiscoverCommunitiesPage extends StatefulWidget {
  const DiscoverCommunitiesPage({super.key});

  @override
  State<DiscoverCommunitiesPage> createState() => _DiscoverCommunitiesPageState();
}

class _DiscoverCommunitiesPageState extends State<DiscoverCommunitiesPage> {
  late Future<List<Community>> _futureCommunities;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _createNameController = TextEditingController();
  final TextEditingController _createDescController = TextEditingController();


  static const String apiBase = 'https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id';
  String get _baseUrl => apiBase;

  bool get _isAdminFlag {
  final request = context.read<CookieRequest>();
  return request.jsonData["is_admin"] == true;
}



  @override
  void initState() {
    super.initState();
    _futureCommunities = _fetchCommunities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _createNameController.dispose();
    _createDescController.dispose();
    super.dispose();
  }

  Widget _buildBottomNav() {
    return _isAdminFlag
        ? const MainNavbarAdmin(currentIndex: 4)
        : const MainNavbar(currentIndex: 1);
  }

  Future<void> _openEditCommunityDialog(Community community) async {
    final nameController = TextEditingController(text: community.name);
    final descController = TextEditingController(text: community.description);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            Future<void> handleSave() async {
              final name = nameController.text.trim();
              final desc = descController.text.trim();

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name is required.')),
                );
                return;
              }

              setStateDialog(() => isSubmitting = true);

              final request = context.read<CookieRequest>();
              final url = '$_baseUrl/community/${community.id}/update/';

              try {
                final resp = await request.postJson(
                  url,
                  jsonEncode({'name': name, 'description': desc}),
                );

                if (!mounted) return;

                if (resp is Map) {
                  final String? code = resp['code'] as String?;
                  final String message =
                      (resp['message'] as String?) ?? 'Community updated successfully.';

                  if (code == 'duplicate_name') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Community name already exists. Please use a different name.'),
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
                    const SnackBar(content: Text('Community updated.')),
                  );
                }

                Navigator.of(ctx).pop();
                await _refresh();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to update community.'),
                    backgroundColor: Colors.red,
                  ),
                );
                setStateDialog(() => isSubmitting = false);
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Edit Community',
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
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter community name',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF9CA3AF)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                      controller: descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Describe the community...',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF9CA3AF)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC1D752),
                    foregroundColor: const Color(0xFF082459),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Save Changes', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteCommunity(Community community) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Delete Community',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: const Color(0xFF111827),
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${community.name}"?',
            style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF374151), height: 1.4),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFD1D5DB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
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
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[500],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
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

    if (confirmed != true) return;

    final request = context.read<CookieRequest>();
    final url = '$_baseUrl/community/${community.id}/delete/';

    try {
      final resp = await request.postJson(url, jsonEncode({}));

      if (!mounted) return;

      String message = 'Community deleted.';
      if (resp is Map && resp['message'] is String) {
        message = resp['message'] as String;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red[400]),
      );

      await _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete community.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<Community>> _fetchCommunities() async {
    final request = context.read<CookieRequest>();
    final url = '$_baseUrl/community/api/list/?q=${Uri.encodeQueryComponent(_searchQuery)}';
    final response = await request.get(url);
    final list = response as List<dynamic>;

    return list.map((raw) => Community.fromJson(raw as Map<String, dynamic>)).toList();
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

      if (result is Map && result['status'] != null) {
        final status = result['status'] as String;
        final name = result['community_name'] ?? community.name;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == 'joined' ? 'You have joined $name.' : 'Already a member of $name.',
            ),
          ),
        );

        await _refresh();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unexpected response from server.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to join community. Please try again.')),
      );
    }
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
                  final message = resp['message'] as String? ?? 'Community created successfully.';

                  if (code == 'duplicate_name') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Community name already exists. Please use a different name.'),
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
                await _refresh();
              } catch (e) {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF9CA3AF)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF9CA3AF)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1D5DB),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextButton(
                          onPressed: isSubmitting ? null : () => Navigator.of(ctx).pop(),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
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
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC1D752),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextButton(
                          onPressed: isSubmitting ? null : handleSubmit,
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isAdmin = _isAdminFlag;

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

    
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'FIND YOUR COMMUNITY',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(

                          fontSize: w < 420 ? 24 : 30,
                          letterSpacing: w < 420 ? 1.4 : 2.0,

                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.3,

                          shadows: [
                            Shadow(
                              offset: const Offset(0, 0),
                              blurRadius: 1.8,
                              color: Colors.white.withOpacity(0.35),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const MyCommunitiesPage()),
                                  );
                                },
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
                                child: const Text('SEE MY COMMUNITIES'),
                              ),
                            ),
                          ),
                          if (isAdmin) const SizedBox(width: 12),
                          if (isAdmin)
                            Expanded(
                              child: SizedBox(
                                height: 46,
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
                            ),
                        ],
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
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Discover Communities',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Align(
                              alignment: Alignment.center,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: kIsWeb ? 480 : 280),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(999),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF111827),
                                            fontSize: 14,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Search for a community...',
                                            hintStyle: GoogleFonts.inter(
                                              color: const Color(0xFF6B7280),
                                              fontSize: 14,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          onSubmitted: (value) {
                                            _searchQuery = value;
                                            _refresh();
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _searchQuery = _searchController.text.trim();
                                          _refresh();
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 4),
                                          child: Image.asset(
                                            'assets/image/search.png',
                                            width: 18,
                                            height: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

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
                                        style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                                      ),
                                    );
                                  }

                                  final communities = snapshot.data ?? [];

                                  if (communities.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'No communities found.',
                                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                                      ),
                                    );
                                  }

                                  return RefreshIndicator(
                                    onRefresh: _refresh,
                                    child: GridView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: communities.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: w >= 900 ? 3 : 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: w < 420 ? 0.74 : 0.80,
                                      ),
                                      itemBuilder: (context, index) {
                                        final c = communities[index];
                                        final canOpen = c.isJoined || c.isCreator;

                                        return CommunityCard(
                                          community: c,
                                          showCreatorInfo: _isAdminFlag,
                                          onTap: () {
                                            if (!canOpen) return;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => CommunityDetailPage(communityId: c.id),
                                              ),
                                            );
                                          },
                                          onJoin: () => _joinCommunity(c),
                                          onEdit: () => _openEditCommunityDialog(c),
                                          onDelete: () => _deleteCommunity(c),
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