import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/screens/admin_booking_detail_screen.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:playserve_mobile/booking/theme.dart';
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
      backgroundColor: BookingColors.background,
      body: SafeArea(
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
                  Text('Pending Payments',
                      style: BookingTextStyles.display.copyWith(fontSize: 28)),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Booking>>(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                              child: CircularProgressIndicator(color: BookingColors.lime)),
                        );
                      }
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text('Error: ${snapshot.error}',
                              style: BookingTextStyles.bodyLight),
                        );
                      }
                      final bookings = snapshot.data ?? [];
                      if (bookings.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text('No pending payments',
                              style: BookingTextStyles.bodyLight),
                        );
                      }
                      return Column(
                        children: bookings
                            .map((b) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: AdminBookingTile(
                                    booking: b,
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AdminBookingDetailScreen(
                                            bookingId: b.id,
                                          ),
                                        ),
                                      );
                                      _refresh();
                                    },
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
