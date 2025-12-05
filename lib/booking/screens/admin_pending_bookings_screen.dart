import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/screens/admin_booking_detail_screen.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:playserve_mobile/booking/widgets/admin_booking_tile.dart';
import 'package:provider/provider.dart';
import '../config.dart';

class AdminPendingBookingsScreen extends StatefulWidget {
  const AdminPendingBookingsScreen({super.key});

  @override
  State<AdminPendingBookingsScreen> createState() =>
      _AdminPendingBookingsScreenState();
}

class _AdminPendingBookingsScreenState
    extends State<AdminPendingBookingsScreen> {
  late BookingService service;
  late Future<List<Booking>> future;

  @override
  void initState() {
    super.initState();
    service = BookingService(context.read<CookieRequest>(), baseUrl: kBaseUrl);
    future = service.adminPendingBookings();
  }

  Future<void> _refresh() async {
    setState(() {
      future = service.adminPendingBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Payments')),
      body: FutureBuilder<List<Booking>>(
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
            return const Center(child: Text('No pending payments'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (_, i) => AdminBookingTile(
                booking: bookings[i],
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminBookingDetailScreen(
                        bookingId: bookings[i].id,
                      ),
                    ),
                  );
                  _refresh();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
