import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/theme.dart';

class AdminBookingTile extends StatelessWidget {
  const AdminBookingTile({super.key, required this.booking, required this.onTap});
  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final badge = _statusBadge(booking.status);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        decoration: BookingDecorations.card.copyWith(
          borderRadius: BorderRadius.circular(12),
        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
            const SizedBox(height: 6),
            Text('${booking.bookerName} · ${booking.bookingDate} ${booking.startTime}',
                style: BookingTextStyles.cardSubtitle),
            const SizedBox(height: 4),
            Text('Total: Rp ${booking.totalPrice.toInt()}',
                style: BookingTextStyles.price.copyWith(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  _Badge _statusBadge(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return _Badge('Confirmed', BookingColors.green100, BookingColors.green700);
      case 'PENDING_PAYMENT':
      case 'PENDING':
        return _Badge('Pending', BookingColors.yellow200, BookingColors.navbarBlue);
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
