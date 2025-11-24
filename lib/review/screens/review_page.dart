import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1A2B4C), // navy blue background
        child: Center(
          // TODO: replace this with actual review_list widget
          child: Placeholder() 
        ),
      ),
    );
  }
}
