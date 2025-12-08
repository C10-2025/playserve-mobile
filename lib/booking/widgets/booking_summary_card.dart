import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/theme.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({super.key, required this.booking});
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final badge = _statusBadge(booking.status);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BookingDecorations.card,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.field.name,
                  style: BookingTextStyles.cardTitle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badge.background,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge.label,
                  style: BookingTextStyles.cardSubtitle.copyWith(
                    color: badge.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${booking.bookingDate} · ${booking.startTime} - ${booking.endTime}',
            style: BookingTextStyles.cardSubtitle,
          ),
          const SizedBox(height: 4),
          Text(
            'City: ${booking.field.city}',
            style: BookingTextStyles.cardSubtitle,
          ),
          const SizedBox(height: 10),
          Text(
            'Total: Rp ${booking.totalPrice.toInt()}',
            style: BookingTextStyles.price.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }

  _Badge _statusBadge(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return _Badge(
          'Confirmed',
          BookingColors.green100,
          BookingColors.green700,
        );
      case 'PENDING_PAYMENT':
      case 'PENDING':
        return _Badge(
          'Pending',
          BookingColors.yellow200,
          BookingColors.navbarBlue,
        );
      case 'REJECTED':
      case 'CANCELLED':
        return _Badge('Cancelled', BookingColors.red100, BookingColors.red600);
      default:
        return _Badge(status, BookingColors.gray100, BookingColors.gray700);
    }
  }
}

class _Badge {
  final String label;
  final Color background;
  final Color textColor;
  _Badge(this.label, this.background, this.textColor);
}
