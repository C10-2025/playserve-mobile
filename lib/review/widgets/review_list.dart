import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/review/models/lapangan.dart';
import 'package:playserve_mobile/review/models/review_card.dart';

class ReviewList extends StatelessWidget {
  final List<Lapangan> reviews;

  const ReviewList({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(
        horizontal: width < 500 ? 12 : 20,
        vertical: 20,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width < 500 ? 20 : 48,
            vertical: 28,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2B4C),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Court Reviews",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  SizedBox(
                    width: 120,
                    height: 3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFFB0D235),
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: reviews
                        .map((lap) => ReviewCard(lapangan: lap))
                        .toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
