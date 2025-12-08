import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingBackground extends StatelessWidget {
  const BookingBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          color: BookingColors.background, // Blue background as fallback
          image: DecorationImage(
            image: AssetImage('assets/image/background.png'),
            fit: BoxFit.cover, // Cover the entire area
            opacity: 0.3, // Make it subtle so content is still readable
          ),
        ),
        child: child,
      ),
    );
  }
}

class BookingColors {
  static const background = Color(0xFF1146A9);
  static const panel = Color(0xFF1A2B4C);
  static const navbarBlue = Color(0xFF082459);
  static const lime = Color(0xFFC1D752);
  static const textLight = Color(0xFFF5F5F5);
  static const offWhite = Color(0xFFF0F0F0);
  static const white = Colors.white;
  static const gray800 = Color(0xFF1F2937);
  static const gray700 = Color(0xFF374151);
  static const gray600 = Color(0xFF4B5563);
  static const gray500 = Color(0xFF6B7280);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray100 = Color(0xFFF3F4F6);
  static const green600 = Color(0xFF16A34A);
  static const green700 = Color(0xFF15803D);
  static const green100 = Color(0xFFBBF7D0);
  static const yellow400 = Color(0xFFFACC15);
  static const yellow50 = Color(0xFFFEFCE8);
  static const yellow200 = Color(0xFFFDE68A);
  static const red600 = Color(0xFFDC2626);
  static const red100 = Color(0xFFFEE2E2);
  static const blue50 = Color(0xFFEFF6FF);
  static const blue600 = Color(0xFF2563EB);
}

class BookingTextStyles {
  static TextStyle get display => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    height: 1.3,
    color: Colors.white,
  );
  static TextStyle get headline => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: BookingColors.gray800,
  );
  static TextStyle get title => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: BookingColors.gray800,
  );
  static TextStyle get subtitle => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: BookingColors.gray600,
  );
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: BookingColors.gray700,
  );
  static TextStyle get bodyLight => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: BookingColors.textLight,
  );
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
  static TextStyle get price => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: BookingColors.green600,
  );
  static TextStyle get cardTitle => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: BookingColors.gray800,
  );
  static TextStyle get cardSubtitle => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: BookingColors.gray600,
  );
}

class BookingDecorations {
  static BoxDecoration panel = BoxDecoration(
    color: BookingColors.panel,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(color: Colors.black38, blurRadius: 28, offset: Offset(0, 8)),
    ],
  );

  static BoxDecoration card = BoxDecoration(
    color: BookingColors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: const [
      BoxShadow(
        color: Color.fromARGB(51, 0, 0, 0),
        blurRadius: 12,
        offset: Offset(0, 6),
      ),
    ],
  );

  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: BookingColors.lime,
    foregroundColor: BookingColors
        .navbarBlue, // Changed from white to dark navy for better contrast
    textStyle: BookingTextStyles.button,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    minimumSize: const Size(120, 0), // Minimum width to prevent infinite width
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    foregroundColor: BookingColors.white,
    side: const BorderSide(color: BookingColors.gray200),
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: BookingTextStyles.button.copyWith(
      fontSize: 14,
    ),
  );
}
