import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/review/models/review_item.dart'; // contains ReviewItemNew class
import 'package:playserve_mobile/review/widgets/review_card.dart';
import 'package:playserve_mobile/review/widgets/add_review.dart';
import 'package:playserve_mobile/review/widgets/view_comments.dart';

// Mobile-first, responsive review list
class ReviewList extends StatefulWidget {
  const ReviewList({super.key});

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  List<PlayingField> _fields = [];
  List<ReviewItemNew> _reviews = [];

  bool _loading = true;
  String? _error;

  String _sortOption = 'none';
  String _searchQuery = '';

  // urls
  static const String apiBase = 'https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id';
  static const String _fieldsUrl = '$apiBase/booking/json/';
  static const String _reviewsUrl = '$apiBase/review/json/';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchAll());
  }

  Future<void> _fetchAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final request = context.read<CookieRequest>();

      final resp = await Future.wait([
        request.get(_fieldsUrl),
        request.get(_reviewsUrl),
      ]);

      final fieldsData = resp[0];
      final reviewsData = resp[1];

      final parsedFields = (fieldsData is String) ? json.decode(fieldsData) : fieldsData;
      final parsedReviews = (reviewsData is String) ? json.decode(reviewsData) : reviewsData;

      _fields = parsedFields
          .map<PlayingField>((d) => PlayingField.fromJson(Map<String, dynamic>.from(d)))
          .toList();

      _reviews = parsedReviews
          .map<ReviewItemNew>((d) => ReviewItemNew.fromJson(Map<String, dynamic>.from(d)))
          .toList();

      _applySorting();
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _refreshReviews() async {
    try {
      final request = context.read<CookieRequest>();
      final resp = await request.get(_reviewsUrl);
      final parsed = (resp is String) ? json.decode(resp) : resp;
      setState(() {
        _reviews = parsed
            .map<ReviewItemNew>((d) => ReviewItemNew.fromJson(Map<String, dynamic>.from(d)))
            .toList();
      });
      _applySorting();
    } catch (e) {
      // ignore or show snack
    }
  }

  List<ReviewItemNew> _reviewsForField(String fieldName) {
    return _reviews.where((r) => r.fieldName == fieldName).toList();
  }

  double _computeAvgRating(String fieldName) {
    final related = _reviews.where((r) => r.fieldName == fieldName).toList();
    if (related.isEmpty) return 0.0;
    final total = related.fold<int>(0, (sum, r) => sum + r.rating);
    return total / related.length;
  }

  int _computeReviewCount(String fieldName) {
    return _reviews.where((r) => r.fieldName == fieldName).length;
  }

  void _applySorting() {
    _fields.sort((a, b) {
      final avgA = _computeAvgRating(a.name);
      final avgB = _computeAvgRating(b.name);
      if (_sortOption == 'avg_desc') return avgB.compareTo(avgA);
      if (_sortOption == 'avg_asc') return avgA.compareTo(avgB);
      return b.id.compareTo(a.id);
    });
  }

  List<PlayingField> get _filteredFields {
    final lower = _searchQuery.toLowerCase();
    return _fields.where((f) {
      return f.name.toLowerCase().contains(lower) ||
          f.address.toLowerCase().contains(lower) ||
          f.city.toLowerCase().contains(lower);
    }).toList();
  }

  // Adds new review via the backend and refreshes
  Future<void> _addReview(String fieldName, int rating, String comment) async {
    final request = context.read<CookieRequest>();

    try {
      final url = '$apiBase/review/add-review-flutter/';
      final response = await request.post(
        url,
        jsonEncode({
          'field_name': fieldName,
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response['status'] == 'success') {
        await _refreshReviews();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review successfully submitted!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit review: ${response['message'] ?? ''}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // MAGIC, entah kenapa bisa padahal di login g ditambah apa2 ke json, tapi ini kerja DON'T TOUCH
    final bool isAdmin = request.jsonData['is_admin'] == true;

    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text('Error: $_error'));

    final screenW = MediaQuery.of(context).size.width;
    final horizontalPadding = screenW > 700 ? 24.0 : 12.0;

    return RefreshIndicator(
      onRefresh: _fetchAll,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
        child: Column(
          children: [
            // Search + sort row (compact for mobile)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search by name, city, address',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.white70),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: _sortOption,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'none', child: Text('Default')),
                      DropdownMenuItem(value: 'avg_desc', child: Text('Rating ↓')),
                      DropdownMenuItem(value: 'avg_asc', child: Text('Rating ↑')),
                    ],
                    onChanged: (v) => setState(() {
                      _sortOption = v ?? 'none';
                      _applySorting();
                    }),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // List area
            Expanded(
              child: _filteredFields.isEmpty
                  ? const Center(child: Text('No courts found.', style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: _filteredFields.length,
                      itemBuilder: (context, idx) {
                        final field = _filteredFields[idx];
                        return ReviewCard(
                          field: field,
                          allReviews: _reviews,
                          avgRating: _computeAvgRating(field.name),
                          reviewCount: _computeReviewCount(field.name),
                          onAddReview: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) => AddReviewModal(
                                courtName: field.name,
                                onSubmit: (rating, comment) async {
                                  await _addReview(field.name, rating, comment);
                                },
                              ),
                            );
                          },
                          onViewComments: () {
                            final related = _reviewsForField(field.name);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => ViewCommentsModal(
                                courtName: field.name,
                                address: field.address,
                                pricePerHour: field.pricePerHour.toDouble(),
                                reviews: related,
                                isAdmin: isAdmin,
                                onRefresh: _refreshReviews,
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
