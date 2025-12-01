import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';

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

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String get _baseUrl =>
      kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';

  @override
  void initState() {
    super.initState();
    _futureLoad = _loadCommunity();
  }

  Future<void> _loadCommunity() async {
    final request = context.read<CookieRequest>();
    final url = '$_baseUrl/community/api/community/${widget.communityId}/';

    final data = await request.get(url) as Map<String, dynamic>;
    final postsJson = data['posts'] as List<dynamic>? ?? [];

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

    await request.postJson(
      url,
      jsonEncode({'title': title, 'content': content}),
    );

    _titleController.clear();
    _contentController.clear();
    await _loadCommunity();
  }

  Future<void> _createReply(PostModel post, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final request = context.read<CookieRequest>();
    final url = '$_baseUrl/community/api/posts/${post.id}/reply/';

    await request.postJson(
      url,
      jsonEncode({'content': trimmed}),
    );

    await _loadCommunity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF082459),
      appBar: AppBar(
        backgroundColor: const Color(0xFF082459),
        elevation: 0,
        title: Text(_name ?? 'Community'),
      ),
      body: FutureBuilder<void>(
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
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return SafeArea(
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header
                      Text(
                        _name ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_description != null && _description!.isNotEmpty)
                        Text(
                          _description!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        '$_membersCount members',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // New Discussion
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8,
                              offset: Offset(0, 4),
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Start a New Discussion',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _contentController,
                              decoration: const InputDecoration(
                                labelText: 'Content',
                                border: OutlineInputBorder(),
                              ),
                              minLines: 3,
                              maxLines: 5,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: _createPost,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC1D752),
                                  foregroundColor: const Color(0xFF082459),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Post Discussion',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Posts
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Community Discussions',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_posts.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Text(
                            'No posts yet — be the first to start a discussion!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      else
                        Column(
                          children: _posts.map((post) {
                            final replyController = TextEditingController();
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Post body
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '@${post.author}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          post.content,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 0),

                                  // Replies
                                  if (post.replies.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        children: post.replies.map((reply) {
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(bottom: 8),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '@${reply.author}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      reply.createdAt
                                                          .toLocal()
                                                          .toString()
                                                          .substring(0, 16),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  reply.content,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),

                                  // Reply form
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: replyController,
                                            decoration: const InputDecoration(
                                              hintText: 'Write a reply...',
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () async {
                                            final text =
                                                replyController.text.trim();
                                            if (text.isEmpty) return;
                                            await _createReply(post, text);
                                            replyController.clear();
                                          },
                                          icon: const Icon(Icons.send),
                                          color: const Color(0xFF082459),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
