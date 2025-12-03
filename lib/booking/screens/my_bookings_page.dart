import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/booking.dart';
import '../services/booking_service.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  late BookingService service;
  late Future<List<BookingItem>> _future;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    service = BookingService(request);
    _future = service.fetchMyBookings();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = service.fetchMyBookings();
    });
  }

  Future<void> _cancel(int id) async {
    try {
      await service.cancelBooking(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled')),
      );
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<BookingItem>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final bookings = snapshot.data ?? [];
            if (bookings.isEmpty) {
              return const ListTile(
                  title: Text('No bookings yet'),
                  subtitle: Text('Book a court to see it here'));
            }
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final b = bookings[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(b.field.name),
                    subtitle: Text(
                        '${b.bookingDate.toLocal().toIso8601String().substring(0, 10)} • ${b.startTime} - ${b.endTime}\nStatus: ${b.status}'),
                    trailing: b.canCancel
                        ? TextButton(
                            onPressed: () => _cancel(b.id),
                            child: const Text('Cancel'),
                          )
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
