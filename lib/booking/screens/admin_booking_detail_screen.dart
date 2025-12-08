import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:playserve_mobile/booking/theme.dart';
import 'package:provider/provider.dart';
import '../config.dart';

class AdminBookingDetailScreen extends StatefulWidget {
  const AdminBookingDetailScreen({super.key, required this.bookingId});
  final int bookingId;

  @override
  State<AdminBookingDetailScreen> createState() =>
      _AdminBookingDetailScreenState();
}

class _AdminBookingDetailScreenState extends State<AdminBookingDetailScreen> {
  late BookingService service;
  late Future<Booking> future;
  final _notes = TextEditingController();
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    service = BookingService(context.read<CookieRequest>(), baseUrl: kBaseUrl);
    future = service.adminBookingDetail(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookingColors.background,
      appBar: AppBar(
        backgroundColor: BookingColors.navbarBlue,
        foregroundColor: Colors.white,
        title: const Text('Verify Booking'),
      ),
      body: SafeArea(
        child: FutureBuilder<Booking>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: BookingColors.lime));
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                    style: BookingTextStyles.bodyLight),
              );
            }
            final booking = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BookingDecorations.panel,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.field.name,
                        style: BookingTextStyles.display.copyWith(fontSize: 26)),
                    const SizedBox(height: 6),
                    Text('${booking.bookingDate} ${booking.startTime} - ${booking.endTime}',
                        style:
                            BookingTextStyles.cardSubtitle.copyWith(color: BookingColors.textLight)),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BookingDecorations.card,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _row('Booker', '${booking.bookerName} (${booking.bookerPhone})'),
                          _row('Amount', 'Rp ${booking.totalPrice.toInt()}'),
                          _row('Status', booking.status),
                          if (booking.notes != null && booking.notes!.isNotEmpty)
                            _row('Notes', booking.notes!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (booking.paymentProofUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          booking.paymentProofUrl!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notes,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Admin notes (optional)',
                        labelStyle: BookingTextStyles.cardSubtitle,
                        filled: true,
                        fillColor: BookingColors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: BookingDecorations.primaryButton,
                            onPressed: _processing ? null : () => _decide('CONFIRM', booking.id),
                            child: const Text('Confirm Payment'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: BookingDecorations.secondaryButton,
                            onPressed: _processing ? null : () => _decide('REJECT', booking.id),
                            child: const Text('Reject'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
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
              style: BookingTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _decide(String decision, int id) async {
    setState(() => _processing = true);
    try {
      await service.adminVerifyBooking(id, decision, notes: _notes.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Updated: $decision')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      setState(() => _processing = false);
    }
  }
}
