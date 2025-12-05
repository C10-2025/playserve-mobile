import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'field_list_screen.dart';
import 'my_bookings_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.booking});
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Success')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 72),
            const SizedBox(height: 12),
            Text('Court: ${booking.field.name}', style: const TextStyle(fontSize: 18)),
            Text('Date: ${booking.bookingDate}'),
            Text('Time: ${booking.startTime} - ${booking.endTime}'),
            Text('Total: Rp ${booking.totalPrice.toInt()}'),
            Text('Status: ${booking.status}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
                ),
                child: const Text('View My Bookings'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const FieldListScreen()),
                  (_) => false,
                ),
                child: const Text('Book another court'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
