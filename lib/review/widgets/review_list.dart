import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:playserve_mobile/booking/models/playing_field.dart'; // <-- updated model import
import 'package:playserve_mobile/review/models/review_item.dart'; // ReviewItemNew

import 'package:playserve_mobile/review/widgets/review_card.dart';
import 'package:playserve_mobile/review/widgets/add_review.dart';
import 'package:playserve_mobile/review/widgets/view_comments.dart';

// TODO: implement login
class ReviewList extends StatefulWidget {
  const ReviewList({super.key});

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  // Data Holders (Note that the _fetchAll() function is void due to this field being init first)
  List<PlayingField> _fields = [];
  List<ReviewItemNew> _reviews = [];

  // Loading / error state
  bool _loading = true;
  String? _error;

  // Sorting + searching state
  String _sortOption = 'none'; // none, avg_desc, avg_asc
  String _searchQuery = "";

  // ENDPOINTS
  static const String _fieldsUrl = 'http://127.0.0.1:8000/booking/json/';
  static const String _reviewsUrl = 'http://127.0.0.1:8000/review/json/';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchAll());
  }

  // === CookieRequest METHODS ===
  // JSON fetcher
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

      final parsedFields = (fieldsData is String)
          ? json.decode(fieldsData)
          : fieldsData;

      final parsedReviews = (reviewsData is String)
          ? json.decode(reviewsData)
          : reviewsData;

      _fields = parsedFields
          .map<PlayingField>(
            (d) => PlayingField.fromJson(Map<String, dynamic>.from(d)),
          )
          .toList();
      _applySorting(); // Sort the fields immediately

      _reviews = parsedReviews
          .map<ReviewItemNew>(
            (d) => ReviewItemNew.fromJson(Map<String, dynamic>.from(d)),
          )
          .toList();

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  // Get up to date reviews after an operation, used on refresh
  Future<void> _refreshReviews() async {
    final request = context.read<CookieRequest>();

    final resp = await request.get(_reviewsUrl);

    final parsed = (resp is String) ? json.decode(resp) : resp;

    setState(() {
      _reviews = parsed
          .map<ReviewItemNew>(
            (d) => ReviewItemNew.fromJson(Map<String, dynamic>.from(d)),
          )
          .toList();
    });
    _applySorting(); // immediately re-sort reviews after this
  }

  // === HELPERS ===
  // Get reviews for a field by name
  List<ReviewItemNew> _reviewsForField(String fieldName) {
    return _reviews.where((r) => r.fieldName == fieldName).toList();
  }

  // Avg rating
  double _computeAvgRating(String fieldName) {
    final related = _reviews.where((r) => r.fieldName == fieldName).toList();
    if (related.isEmpty) return 0;

    final total = related.fold(0, (sum, r) => sum + r.rating);
    return total / related.length;
  }

  // Review count
  int _computeReviewCount(String fieldName) {
    return _reviews.where((r) => r.fieldName == fieldName).length;
  }

  // Sorting logic
  void _applySorting() {
    _fields.sort((a, b) {
      final avgA = _computeAvgRating(a.name);
      final avgB = _computeAvgRating(b.name);

      if (_sortOption == 'avg_desc') {
        // Highest → Lowest
        return avgB.compareTo(avgA);
      } else if (_sortOption == 'avg_asc') {
        // Lowest → Highest
        return avgA.compareTo(avgB);
      }

      // Default same as Django: sort by -id
      return b.id.compareTo(a.id);
    });
  }

  // Get filtered list
  List<PlayingField> get _filteredFields {
    final lower = _searchQuery.toLowerCase();

    return _fields.where((f) {
      return f.name.toLowerCase().contains(lower) ||
          f.address.toLowerCase().contains(lower) ||
          f.city.toLowerCase().contains(lower);
    }).toList();
  }

  // Adds new review from the form in add_review.dart to the django backend
  Future<void> _addReview(String fieldName, int rating, String comment) async {
    final request = context.read<CookieRequest>();

    try {
      final url = "http://127.0.0.1:8000/review/add-review-flutter/";

      final response = await request.postJson(
        url,
        jsonEncode({
          "field_name": fieldName,
          "rating": rating,
          "comment": comment,
        }),
      );

      if (response["status"] == "success") {
        // Refresh reviews from Django and re-sort after posting
        await _refreshReviews();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Review successfully submitted!")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to submit review.")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error occurred: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text("Error: $_error"));
    }

    final width = MediaQuery.of(context).size.width;
    final containerWidth = width > 1100 ? 1100.0 : width;

    return Center(
      child: Container(
        width: containerWidth,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        color: const Color(0xFF1A2B4C),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Text(
              "Court Reviews",
              style: TextStyle(
                fontSize: width < 450 ? 20 : 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              height: 3,
              width: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFB0D235),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 28),

            // SORTING + SEARCH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LEFT: Sorting
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _sortOption,
                    dropdownColor: Colors.white,
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.black),
                    items: const [
                      DropdownMenuItem(
                        value: 'none',
                        child: Text("Rating: Default"),
                      ),
                      DropdownMenuItem(
                        value: 'avg_desc',
                        child: Text("Rating: High → Low"),
                      ),
                      DropdownMenuItem(
                        value: 'avg_asc',
                        child: Text("Rating: Low → High"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortOption = value!;
                        _applySorting();
                      });
                    },
                  ),
                ),

                // RIGHT: Search bar
                SizedBox(
                  width: 180,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.15),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            // SCROLL AREA
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2B4C),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),

                child: _filteredFields.isEmpty
                    ? const Center(
                        child: Text(
                          "No courts found.",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(right: 8),
                        itemCount: _filteredFields.length,
                        itemBuilder: (context, index) {
                          final field = _filteredFields[index];

                          return ReviewCard(
                            field: field,
                            allReviews: _reviews,

                            onAddReview: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => AddReviewModal(
                                  courtName: field.name,
                                  onSubmit: (rating, comment) async {
                                    await _addReview(
                                      field.name,
                                      rating,
                                      comment,
                                    );
                                  },
                                ),
                              );
                            },

                            onViewComments: () {
                              final relatedReviews = _reviewsForField(
                                field.name,
                              );

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => ViewCommentsModal(
                                  courtName: field.name,
                                  address: field.address,
                                  pricePerHour: field.pricePerHour,
                                  reviews: relatedReviews,
                                  isAdmin:
                                      request.jsonData["is_admin"] ?? false,
                                  onRefresh: () {
                                    // call refresh of review_list
                                    _refreshReviews();
                                  },
                                ),
                              );
                            },
                            avgRating: _computeAvgRating(field.name),
                            reviewCount: _computeReviewCount(field.name),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
