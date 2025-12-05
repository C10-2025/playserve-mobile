import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/booking.dart';

class AdminBookingTile extends StatelessWidget {
  const AdminBookingTile({super.key, required this.booking, required this.onTap});
  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(booking.field.name),
        subtitle: Text('${booking.bookerName} • ${booking.bookingDate} ${booking.startTime}'),
        trailing: Text(booking.status),
        onTap: onTap,
      ),
    );
  }
}
