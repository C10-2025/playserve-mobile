import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
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
      appBar: AppBar(title: const Text('Verify Booking')),
      body: FutureBuilder<Booking>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final booking = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.field.name,
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${booking.bookingDate} ${booking.startTime} - ${booking.endTime}'),
                Text('Booker: ${booking.bookerName} (${booking.bookerPhone})'),
                Text('Total: Rp ${booking.totalPrice.toInt()}'),
                const SizedBox(height: 8),
                if (booking.paymentProofUrl != null)
                  Image.network(booking.paymentProofUrl!,
                      height: 180, fit: BoxFit.cover),
                const SizedBox(height: 12),
                TextField(
                  controller: _notes,
                  decoration: const InputDecoration(
                    labelText: 'Admin notes (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _processing
                            ? null
                            : () => _decide('CONFIRM', booking.id),
                        child: const Text('Confirm Payment'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _processing
                            ? null
                            : () => _decide('REJECT', booking.id),
                        child: const Text('Reject'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
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
