import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:playserve_mobile/booking/theme.dart';
import 'package:playserve_mobile/booking/widgets/booking_summary_card.dart';
import 'package:playserve_mobile/main_navbar.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import 'field_list_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late BookingService service;
  late Future<List<Booking>> future;

  @override
  void initState() {
    super.initState();
    service = BookingService(context.read<CookieRequest>(), baseUrl: kBaseUrl);
    future = service.fetchMyBookings();
  }

  Future<void> _refresh() async {
    setState(() {
      future = service.fetchMyBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BookingBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BookingDecorations.panel,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Bookings',
                          style: BookingTextStyles.display.copyWith(
                            fontSize: 28,
                          ),
                        ),
                        ElevatedButton(
                          style: BookingDecorations.primaryButton,
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FieldListScreen(),
                            ),
                          ),
                          child: const Text('Book New Court'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<Booking>>(
                      future: future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: BookingColors.lime,
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: BookingTextStyles.bodyLight,
                            ),
                          );
                        }
                        final bookings = snapshot.data ?? [];
                        if (bookings.isEmpty) {
                          return _emptyState(context);
                        }
                        final stats = _buildStats(bookings);
                        return Column(
                          children: [
                            _statsRow(stats),
                            const SizedBox(height: 16),
                            ...bookings.map(
                              (b) => BookingSummaryCard(booking: b),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MainNavbar(currentIndex: 3),
    );
  }

  Widget _statsRow(Map<String, int> stats) {
    Widget box(String label, int value, Color color) => Container(
      decoration: BoxDecoration(
        color: BookingColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(51, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      child: Column(
        children: [
          Text(
            '$value',
            style: BookingTextStyles.title.copyWith(color: color, fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: BookingTextStyles.cardSubtitle),
        ],
      ),
    );

    return Row(
      children: [
        Expanded(
          child: box(
            'Upcoming',
            stats['confirmed'] ?? 0,
            BookingColors.blue600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: box('Pending', stats['pending'] ?? 0, BookingColors.yellow400),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: box(
            'Completed',
            stats['completed'] ?? 0,
            BookingColors.green600,
          ),
        ),
      ],
    );
  }

  Map<String, int> _buildStats(List<Booking> bookings) {
    int upcoming = 0, pending = 0, completed = 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final b in bookings) {
      final status = b.status.toUpperCase();
      final bookingDate = DateTime.parse(b.bookingDate);

      // Upcoming: date >= today and status CONFIRMED or PENDING_PAYMENT
      if (bookingDate.isAtSameMomentAs(today) || bookingDate.isAfter(today)) {
        if (status == 'CONFIRMED' || status == 'PENDING_PAYMENT') {
          upcoming++;
        }
      }

      if (status.startsWith('PENDING')) pending++;
      if (status == 'COMPLETED') completed++;
    }
    return {'confirmed': upcoming, 'pending': pending, 'completed': completed};
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Icon(
            Icons.sports_tennis,
            size: 64,
            color: BookingColors.textLight,
          ),
          const SizedBox(height: 8),
          Text('No bookings yet', style: BookingTextStyles.bodyLight),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FieldListScreen()),
            ),
            child: const Text('Book a court'),
          ),
        ],
      ),
    );
  }
}
