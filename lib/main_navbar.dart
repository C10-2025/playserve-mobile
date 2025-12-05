import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:playserve_mobile/authentication/screens/home_page.dart';

class MainNavbar extends StatelessWidget {
  final int currentIndex;

  const MainNavbar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0A1F63),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              index: 0,
              icon: LucideIcons.home,
              page: const HomePage(),
            ),
            _buildNavItem(
              context,
              index: 1,
              icon: LucideIcons.messageSquare,
              // page: const CommunityPage(),
            ),
            _buildNavItem(
              context,
              index: 2,
              icon: LucideIcons.radar, // 🔁 Ganti 'tennis' (belum ada di 0.2.57)
              // page: const MatchPage(),
            ),
            _buildNavItem(
              context,
              index: 3,
              icon: LucideIcons.calendar, // 🔁 Ganti 'calendarEdit'
              // page: const BookingPage(),
            ),
            _buildNavItem(
              context,
              index: 4,
              icon: LucideIcons.star,
              // page: const FavoritesPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    Widget? page,
  }) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () {
        if (!isActive && page != null) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => page,
              transitionDuration: const Duration(milliseconds: 250),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(0.5, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ));
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? const Color(0xFFB8D243) : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 26,
          color: isActive ? const Color(0xFF0A1F63) : Colors.white,
        ),
      ),
    );
  }
}