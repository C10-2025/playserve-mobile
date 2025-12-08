import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/post.dart';
import 'package:playserve_mobile/main_navbar.dart';
import 'package:playserve_mobile/main_navbar_admin.dart'; 
import 'package:playserve_mobile/header.dart';

class CommunityDetailPage extends StatefulWidget {
  final int communityId;

  const CommunityDetailPage({super.key, required this.communityId});

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  late Future<void> _futureLoad;
  String? _name;
  String? _description;
  int _membersCount = 0;
  List<PostModel> _posts = [];
  bool _isAdminFlag = false;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String get _baseUrl =>
      kIsWeb ? 'https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id' : 'http://10.0.2.2:8000';

  @override
  void initState() {
    super.initState();
    _futureLoad = _loadCommunity();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAdminFlag();
    });
  }

  Future<void> _loadCommunity() async {
    final request = context.read<CookieRequest>();
    final url = '$_baseUrl/community/api/community/${widget.communityId}/';

    final resp = await request.get(url);

    if (resp is Map && resp['error'] != null) {
      throw Exception(resp['error']);
    }

    final data = resp as Map<String, dynamic>;
    final postsJson = data['posts'] as List<dynamic>? ?? [];

    if (!mounted) return;
    setState(() {
      _name = data['name'] as String?;
      _description = data['description'] as String?;
      _membersCount = data['members_count'] as int? ?? 0;
      _posts = postsJson
          .map((raw) => PostModel.fromJson(raw as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _createPost() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content are required.')),
      );
      return;
    }

    final request = context.read<CookieRequest>();
    final url = '$_baseUrl/community/api/community/${widget.communityId}/posts/';

    final result = await request.postJson(
      url,
      jsonEncode({'title': title, 'content': content}),
    );

    if (result is Map && result['error'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'].toString())),
      );
      return;
    }

    _titleController.clear();
    _contentController.clear();
    await _loadCommunity();
  }

  Future<void> _createReply(PostModel post, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final request = context.read<CookieRequest>();
    final url = '$_baseUrl/community/api/posts/${post.id}/reply/';

    final result = await request.postJson(
      url,
      jsonEncode({'content': trimmed}),
    );

    if (result is Map && result['error'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'].toString())),
      );
      return;
    }

    await _loadCommunity();
  }

  Future<void> _deletePost(PostModel post) async {
    final request = context.read<CookieRequest>();
    final url = '$_baseUrl/community/api/posts/${post.id}/delete/';

    try {
      final resp = await request.postJson(url, jsonEncode({}));

      if (!mounted) return;

      String message = 'Post deleted.';
      if (resp is Map && resp['message'] is String) {
        message = resp['message'] as String;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      await _loadCommunity();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete post.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmDeletePost(PostModel post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Delete Post',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: const Color(0xFF111827),
            ),
          ),
          content: Text(
            'Delete this post? This action cannot be undone.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF374151),
              height: 1.4,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 15,
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
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
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

    if (confirmed == true) {
      await _deletePost(post);
    }
  }

  Future<void> _deleteReply(dynamic reply) async {
    final request = context.read<CookieRequest>();
    final url = '$_baseUrl/community/api/replies/${reply.id}/delete/';

    try {
      final resp = await request.postJson(url, jsonEncode({}));

      if (!mounted) return;

      String message = 'Reply deleted.';
      if (resp is Map && resp['message'] is String) {
        message = resp['message'] as String;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      await _loadCommunity();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete reply.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmDeleteReply(dynamic reply) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Delete Reply',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: const Color(0xFF111827),
            ),
          ),
          content: Text(
            'Delete this reply? This action cannot be undone.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF374151),
              height: 1.4,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 15,
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
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
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

    if (confirmed == true) {
      await _deleteReply(reply);
    }
  }

  Future<void> _loadAdminFlag() async {
    final request = context.read<CookieRequest>();
    try {
      final resp = await request.get('$_baseUrl/auth/check_admin_status/');
      if (!mounted) return;

      setState(() {
        _isAdminFlag = (resp is Map && resp['is_admin'] == true);
      });
    } catch (e) {
      debugPrint('Failed to load admin status: $e');
      if (!mounted) return;
      setState(() {
        _isAdminFlag = false;
      });
    }
  }

  Widget _buildBottomNav() {
    return _isAdminFlag
        ? const MainNavbarAdmin(
            currentIndex: 2) 
        : const MainNavbar(currentIndex: 1);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m minute${m == 1 ? '' : 's'} ago';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h hour${h == 1 ? '' : 's'} ago';
    }
    final d = diff.inDays;
    return '$d day${d == 1 ? '' : 's'} ago';
  }

  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              Text(
                (_name ?? '').toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: kIsWeb ? 44 : 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2.2,
                  height: 1.05,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 0),
                      blurRadius: 1.8,
                      color: Colors.white.withOpacity(0.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$_membersCount member${_membersCount == 1 ? '' : 's'}',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              if (_description != null && _description!.trim().isNotEmpty)
                Text(
                  _description!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade300,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.25)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start a New Discussion',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Enter a topic title...",
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
                minLines: 3,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your thoughts or questions here',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _createPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC1D752),
                    foregroundColor: const Color(0xFF111827),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Post Discussion',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey.shade700, thickness: 1),
        const SizedBox(height: 12),
        Text(
          'Community Discussions',
          textAlign: kIsWeb ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPostCard(PostModel post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withOpacity(0.35)),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '@${post.author}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        post.content,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _timeAgo(post.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (_isAdminFlag)
                      SizedBox(
                        height: 30,
                        child: TextButton(
                          onPressed: () => _confirmDeletePost(post),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red[500],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            'Delete Post',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: post.replies.isEmpty
                ? Text(
                    'No replies yet — be the first to respond!',
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  )
                : Column(
                    children: post.replies.map((reply) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '@${reply.author}',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  reply.createdAt
                                      .toLocal()
                                      .toString()
                                      .substring(0, 16),
                                  style: GoogleFonts.inter(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              reply.content,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                            if (_isAdminFlag) ...[
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => _confirmDeleteReply(reply),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red[500],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    'Delete',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          _ReplyBox(
            onSubmit: (text) => _createReply(post, text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: FutureBuilder<void>(
                    future: _futureLoad,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          _name == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading community.\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 900),
                            child: _posts.isEmpty
                                ? ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      _buildTopSection(),
                                      Center(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 8),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 32,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.grey
                                                  .withOpacity(0.3),
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
                                              Text(
                                                'Be the first to start a discussion!',
                                                style: GoogleFonts.inter(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'No posts yet — share your thoughts using the form above.',
                                                style: GoogleFonts.inter(
                                                  color:
                                                      Colors.grey.shade600,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: _posts.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == 0) return _buildTopSection();
                                      final post = _posts[index - 1];
                                      return _buildPostCard(post);
                                    },
                                  ),
                          ),
                        ),
                      );
                    },
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

class _ReplyBox extends StatefulWidget {
  final Future<void> Function(String text) onSubmit;

  const _ReplyBox({required this.onSubmit});

  @override
  State<_ReplyBox> createState() => _ReplyBoxState();
}

class _ReplyBoxState extends State<_ReplyBox> {
  final TextEditingController _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _submitting) return;

    setState(() => _submitting = true);
    try {
      await widget.onSubmit(text);
      _controller.clear();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Write a reply...',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: const BorderSide(
                    color: Color(0xFF2563EB),
                    width: 1.5,
                  ),
                ),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            height: 40,
            child: ElevatedButton(
              onPressed: _submitting ? null : _send,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                elevation: 2,
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Reply'),
            ),
          ),
        ],
      ),
    );
  }
}