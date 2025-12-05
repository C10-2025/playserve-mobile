import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFC6DA44) : const Color(0xFF9BB04A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 1.2,
            letterSpacing: 0.5,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
