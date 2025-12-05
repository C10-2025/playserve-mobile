import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:playserve_mobile/booking/widgets/booking_summary_card.dart';
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
      appBar: AppBar(title: const Text('My Bookings')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Booking>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final bookings = snapshot.data ?? [];
            if (bookings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No bookings yet'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FieldListScreen(),
                        ),
                      ),
                      child: const Text('Book a court'),
                    )
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (_, i) => BookingSummaryCard(booking: bookings[i]),
            );
          },
        ),
      ),
    );
  }
}
