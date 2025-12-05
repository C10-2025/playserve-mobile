import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/models/booking_draft.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:provider/provider.dart';
import '../models/api_error.dart';
import '../config.dart';
import 'booking_success_screen.dart';

class BookingStep3PaymentScreen extends StatefulWidget {
  const BookingStep3PaymentScreen({super.key, required this.draft});
  final BookingDraft draft;

  @override
  State<BookingStep3PaymentScreen> createState() =>
      _BookingStep3PaymentScreenState();
}

class _BookingStep3PaymentScreenState extends State<BookingStep3PaymentScreen> {
  File? proof;
  bool agreed = false;
  bool saving = false;
  String? errorMsg;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final service = BookingService(request, baseUrl: kBaseUrl);
    final approxTotal =
        ((widget.draft.durationHours ?? 0) * widget.draft.field.pricePerHour).toInt();

    return Scaffold(
      appBar: AppBar(title: const Text('Step 3: Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Field: ${widget.draft.field.name}'),
            Text('Date: ${_fmtDate(widget.draft.bookingDate)}'),
            Text('Time: ${widget.draft.startTime} for ${widget.draft.durationHours}h'),
            Text('Approx total: Rp $approxTotal'),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: Text(proof == null ? 'Upload payment proof (optional)' : 'Change file'),
              onPressed: () async {
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() => proof = File(picked.path));
                }
              },
            ),
            Row(
              children: [
                Checkbox(
                  value: agreed,
                  onChanged: (v) => setState(() => agreed = v ?? false),
                ),
                const Expanded(
                    child: Text('I agree to the terms and 24h cancellation policy.')),
              ],
            ),
            if (errorMsg != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(errorMsg!, style: const TextStyle(color: Colors.red)),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saving ? null : () => _submit(service),
                child: saving
                    ? const SizedBox(
                        width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Confirm Booking'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BookingService service) async {
    if (!agreed) {
      setState(() => errorMsg = 'Please agree to the terms');
      return;
    }
    if (widget.draft.bookingDate == null ||
        widget.draft.startTime == null ||
        widget.draft.durationHours == null) {
      setState(() => errorMsg = 'Schedule is incomplete.');
      return;
    }
    setState(() {
      saving = true;
      errorMsg = null;
    });
    try {
      final endTime = _computeEnd(widget.draft.startTime!, widget.draft.durationHours!);
      final Booking booking = await service.createBooking(
        fieldId: widget.draft.field.id,
        bookingDate: _fmtDate(widget.draft.bookingDate),
        startTime: widget.draft.startTime!,
        endTime: endTime,
        durationHours: widget.draft.durationHours!,
        bookerName: widget.draft.bookerName ?? '',
        bookerPhone: widget.draft.bookerPhone ?? '',
        bookerEmail: widget.draft.bookerEmail ?? '',
        notes: widget.draft.notes,
      );

      if (proof != null) {
        try {
          await service.uploadPaymentProof(bookingId: booking.id, file: proof!);
        } catch (e) {
          // keep booking as pending, show warning
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Proof upload failed: $e')),
            );
          }
        }
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BookingSuccessScreen(booking: booking)),
      );
    } catch (e) {
      setState(() => errorMsg = e.toString());
    } finally {
      setState(() => saving = false);
    }
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _computeEnd(String startTime, double durationHours) {
    final parts = startTime.split(':');
    final sh = int.tryParse(parts[0]) ?? 0;
    final sm = int.tryParse(parts[1]) ?? 0;
    final startMinutes = sh * 60 + sm;
    final endMinutes = startMinutes + (durationHours * 60).toInt();
    final h = (endMinutes ~/ 60).toString().padLeft(2, '0');
    final m = (endMinutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }
}
