import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/theme.dart';
import 'field_list_screen.dart';
import 'my_bookings_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.booking});
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookingColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BookingDecorations.panel,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFBBF7D0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: BookingColors.green700, size: 44),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Text('Booking Created Successfully!',
                          style: BookingTextStyles.title.copyWith(fontSize: 22)),
                      const SizedBox(height: 6),
                      Text(
                        'Your booking is awaiting payment confirmation.',
                        style: BookingTextStyles.cardSubtitle
                            .copyWith(color: BookingColors.textLight),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BookingDecorations.card,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Booking Details', style: BookingTextStyles.title.copyWith(fontSize: 18)),
                      const SizedBox(height: 12),
                      _row('Court', booking.field.name),
                      _row('Date', booking.bookingDate),
                      _row('Time', '${booking.startTime} - ${booking.endTime}'),
                      _row('Duration', '${booking.durationHours} hour(s)'),
                      const Divider(),
                      _row('Total', 'Rp ${booking.totalPrice.toInt()}',
                          valueStyle: BookingTextStyles.price),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: BookingColors.blue50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: BookingColors.gray200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: BookingColors.blue600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'We will verify your payment within 1-2 hours. You\'ll receive confirmation once approved.',
                          style: BookingTextStyles.cardSubtitle,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: BookingDecorations.primaryButton,
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
                    style: BookingDecorations.secondaryButton,
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
        ),
      ),
    );
  }

  Widget _row(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: BookingTextStyles.cardSubtitle),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: valueStyle ?? BookingTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}
