import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1A2B4C), // navy blue background
        child: Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Find Your ",
                  style: TextStyle(
                    color: Colors.white, // white text
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "Perfect Court",
                  style: TextStyle(
                    color: Color(0xFFC1D752), // lime green
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
