import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/booking.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({super.key, required this.booking});
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(booking.field.name),
        subtitle: Text(
            '${booking.bookingDate} • ${booking.startTime} - ${booking.endTime}\nStatus: ${booking.status}'),
      ),
    );
  }
}
