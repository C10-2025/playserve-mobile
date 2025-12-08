import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/booking.dart';
import 'package:playserve_mobile/booking/models/booking_draft.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:playserve_mobile/booking/theme.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../models/api_error.dart';
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
        ((widget.draft.durationHours ?? 0) * widget.draft.field.pricePerHour)
            .toInt();

    return Scaffold(
      body: BookingBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BookingDecorations.panel,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _progress(step: 3),
                          const SizedBox(height: 24),
                          Text(
                            'Payment & Confirmation',
                            style: BookingTextStyles.title,
                          ),
                          const SizedBox(height: 16),
                          _summaryCard(approxTotal),
                          const SizedBox(height: 16),
                          _qrisBlock(),
                          const SizedBox(height: 16),
                          _uploadBlock(),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: agreed,
                                onChanged: (v) =>
                                    setState(() => agreed = v ?? false),
                                activeColor: BookingColors.green600,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'I agree to the terms and 24h cancellation policy.',
                                  style: BookingTextStyles.cardSubtitle
                                      .copyWith(color: BookingColors.textLight),
                                ),
                              ),
                            ],
                          ),
                          if (errorMsg != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                errorMsg!,
                                style: const TextStyle(
                                  color: BookingColors.red600,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: BookingDecorations.secondaryButton,
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Back'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: BookingDecorations.primaryButton,
                                  onPressed: saving
                                      ? null
                                      : () => _submit(service),
                                  child: saving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Confirm Booking'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _progress({required int step}) {
    Widget circle(int number, bool active) => Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: active ? BookingColors.lime : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? BookingColors.lime : BookingColors.gray200,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: BookingTextStyles.title.copyWith(
          fontSize: 16,
          color: active ? BookingColors.navbarBlue : BookingColors.gray600,
        ),
      ),
    );

    Widget connector() =>
        Expanded(child: Container(height: 2, color: BookingColors.gray200));

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              circle(1, true),
              const SizedBox(height: 6),
              Text(
                'Your Info',
                style: BookingTextStyles.cardSubtitle.copyWith(
                  color: BookingColors.textLight,
                ),
              ),
            ],
          ),
        ),
        connector(),
        Expanded(
          child: Column(
            children: [
              circle(2, true),
              const SizedBox(height: 6),
              Text(
                'Date & Time',
                style: BookingTextStyles.cardSubtitle.copyWith(
                  color: BookingColors.textLight,
                ),
              ),
            ],
          ),
        ),
        connector(),
        Expanded(
          child: Column(
            children: [
              circle(3, true),
              const SizedBox(height: 6),
              Text(
                'Payment',
                style: BookingTextStyles.cardSubtitle.copyWith(
                  color: BookingColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(int approxTotal) {
    return Container(
      decoration: BookingDecorations.card,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: BookingTextStyles.title.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 10),
          _summaryRow('Court', widget.draft.field.name),
          _summaryRow('Date', _fmtDate(widget.draft.bookingDate)),
          _summaryRow(
            'Time',
            '${widget.draft.startTime ?? ""} for ${widget.draft.durationHours ?? "-"}h',
          ),
          const Divider(),
          _summaryRow(
            'Total',
            'Rp $approxTotal',
            valueStyle: BookingTextStyles.price,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {TextStyle? valueStyle}) {
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

  Widget _qrisBlock() {
    return Container(
      decoration: BookingDecorations.card.copyWith(
        borderRadius: BorderRadius.circular(8),
        color: BookingColors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Instructions',
            style: BookingTextStyles.title.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'Scan the QRIS code with your banking app and upload the payment proof.',
            style: BookingTextStyles.body,
          ),
          const SizedBox(height: 12),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: BookingColors.gray100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: BookingColors.gray200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'image/dummy_qris.jpg',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.qr_code_2,
                        size: 64,
                        color: BookingColors.gray500,
                      ),
                      SizedBox(height: 8),
                      Text('QRIS Code'),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadBlock() {
    return Container(
      decoration: BookingDecorations.card.copyWith(
        borderRadius: BorderRadius.circular(8),
        color: BookingColors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Payment Proof',
            style: BookingTextStyles.title.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: Text(
                proof == null ? 'Upload' : 'Change file',
                style: BookingTextStyles.cardSubtitle.copyWith(
                  color: BookingColors.gray600,
                ),
              ),
              style: BookingDecorations.secondaryButton.copyWith(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                alignment: Alignment.centerLeft,
              ),
              onPressed: () async {
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null) {
                  setState(() => proof = File(picked.path));
                }
              },
            ),
          ),
          if (proof != null) ...[
            const SizedBox(height: 8),
            Text(
              'Selected: ${proof!.path.split('/').last}',
              style: BookingTextStyles.cardSubtitle,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _submit(BookingService service) async {
    if (proof == null) {
      setState(() => errorMsg = 'Please upload payment proof to continue');
      return;
    }
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
      final endTime = _computeEnd(
        widget.draft.startTime!,
        widget.draft.durationHours!,
      );
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
        } on ApiError catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Proof upload failed: ${e.message}')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Proof upload failed: $e')));
          }
        }
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(booking: booking),
        ),
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
