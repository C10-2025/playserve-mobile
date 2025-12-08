import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class ClickableInstagramText extends StatefulWidget {
  final String? username;
  final FontWeight fontWeight;

  const ClickableInstagramText({super.key, required this.username, this.fontWeight = FontWeight.w500});

  @override
  State<ClickableInstagramText> createState() => _ClickableInstagramTextState();
}

class _ClickableInstagramTextState extends State<ClickableInstagramText> {
  bool isPressed = false;

  void _openInstagram(String user) async {
    final url = Uri.parse("https://instagram.com/$user");

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ig = widget.username?.trim();

    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapCancel: () => setState(() => isPressed = false),
      onTapUp: (_) {
        setState(() => isPressed = false);
        if (ig != null && ig.isNotEmpty) {
          _openInstagram(ig);
        }
      },
      child: Text(
        ig != null && ig.isNotEmpty ? "@$ig" : "(no instagram)",
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.black54,
          fontWeight: widget.fontWeight,
          decoration:
              isPressed ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}
