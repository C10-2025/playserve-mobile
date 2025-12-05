import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/widgets/review_list.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ReviewList(), 
    );
  }
}
