import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/availability.dart';
import 'package:playserve_mobile/booking/models/booking_draft.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:playserve_mobile/booking/theme.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import 'booking_step3_payment_screen.dart';

class BookingStep2ScheduleScreen extends StatefulWidget {
  const BookingStep2ScheduleScreen({super.key, required this.draft});
  final BookingDraft draft;

  @override
  State<BookingStep2ScheduleScreen> createState() =>
      _BookingStep2ScheduleScreenState();
}

class _BookingStep2ScheduleScreenState
    extends State<BookingStep2ScheduleScreen> {
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  double _duration = 1.0;
  final _notes = TextEditingController();
  AvailabilityResponse? _availability;
  bool _checking = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final service = BookingService(request, baseUrl: kBaseUrl);
    final end = _computeEnd();

    return Scaffold(
      backgroundColor: BookingColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BookingDecorations.panel,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _progress(step: 2),
                const SizedBox(height: 24),
                Text('Pick Date & Time', style: BookingTextStyles.title),
                const SizedBox(height: 12),
                _selector(
                  label: 'Date',
                  value: _fmtDate(_date),
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                ),
                const SizedBox(height: 10),
                _selector(
                  label: 'Start time',
                  value: _fmtTimeFromOfDay(_start),
                  icon: Icons.schedule_outlined,
                  onTap: _pickStart,
                ),
                const SizedBox(height: 14),
                Text('Duration', style: BookingTextStyles.cardSubtitle),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [1.0, 1.5, 2.0, 2.5, 3.0, 4.0]
                      .map((d) => ChoiceChip(
                            label: Text('${d}h',
                                style: BookingTextStyles.cardSubtitle.copyWith(
                                  color: _duration == d
                                      ? BookingColors.green700
                                      : BookingColors.gray700,
                                  fontWeight:
                                      _duration == d ? FontWeight.w700 : FontWeight.w500,
                                )),
                            selected: _duration == d,
                            selectedColor: BookingColors.green100,
                            backgroundColor: BookingColors.gray100,
                            side: BorderSide(
                              color: _duration == d
                                  ? BookingColors.green600
                                  : BookingColors.gray200,
                            ),
                            onSelected: (_) => setState(() => _duration = d),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text('End: ${_fmtTime(end)}',
                    style: BookingTextStyles.cardSubtitle.copyWith(
                      color: BookingColors.textLight,
                    )),
                const SizedBox(height: 12),
                TextField(
                  controller: _notes,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    labelStyle: BookingTextStyles.cardSubtitle,
                    filled: true,
                    fillColor: BookingColors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: BookingColors.green600, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_checking) const LinearProgressIndicator(color: BookingColors.lime),
                if (_availability != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _availability!.available
                          ? BookingColors.green100
                          : BookingColors.red100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _availability!.available
                            ? BookingColors.green600
                            : BookingColors.red600,
                      ),
                    ),
                    child: Text(
                      _availability!.message,
                      style: BookingTextStyles.cardSubtitle.copyWith(
                        color: _availability!.available
                            ? BookingColors.green700
                            : BookingColors.red600,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
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
                        onPressed: () async {
                          setState(() => _checking = true);
                          final resp = await service.checkAvailability(
                            fieldId: widget.draft.field.id,
                            date: _fmtDate(_date),
                            startTime: _fmtTimeFromOfDay(_start),
                            durationHours: _duration,
                            endTime: _fmtTime(end),
                          );
                          setState(() {
                            _availability = resp;
                            _checking = false;
                          });
                        },
                        child: const Text('Check availability'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: BookingDecorations.primaryButton,
                    onPressed: _next,
                    child: const Text('Next: Payment'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selector(
      {required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: BookingColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BookingColors.gray200),
        ),
        child: Row(
          children: [
            Icon(icon, color: BookingColors.gray600),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: BookingTextStyles.cardSubtitle),
                Text(value,
                    style: BookingTextStyles.title.copyWith(
                      fontSize: 16,
                      color: BookingColors.gray800,
                    )),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: BookingColors.gray500),
          ],
        ),
      ),
    );
  }

  Widget _progress({required int step}) {
    Widget circle(int number, bool active) => Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: active ? BookingColors.green600 : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? BookingColors.green600 : BookingColors.gray200,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: BookingTextStyles.title.copyWith(
              fontSize: 16,
              color: active ? Colors.white : BookingColors.gray600,
            ),
          ),
        );

    Widget connector() => Expanded(
          child: Container(
            height: 2,
            color: BookingColors.gray200,
          ),
        );

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              circle(1, true),
              const SizedBox(height: 6),
              Text('Your Info',
                  style: BookingTextStyles.cardSubtitle
                      .copyWith(color: BookingColors.textLight)),
            ],
          ),
        ),
        connector(),
        Expanded(
          child: Column(
            children: [
              circle(2, true),
              const SizedBox(height: 6),
              Text('Date & Time',
                  style: BookingTextStyles.cardSubtitle
                      .copyWith(color: BookingColors.textLight)),
            ],
          ),
        ),
        connector(),
        Expanded(
          child: Column(
            children: [
              circle(3, step >= 3),
              const SizedBox(height: 6),
              Text('Payment',
                  style: BookingTextStyles.cardSubtitle
                      .copyWith(color: BookingColors.textLight)),
            ],
          ),
        ),
      ],
    );
  }

  void _next() {
    if (_availability != null && _availability!.available == false) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Slot unavailable, please adjust.')));
      return;
    }
    widget.draft.bookingDate = _date;
    widget.draft.startTime = _fmtTimeFromOfDay(_start);
    widget.draft.durationHours = _duration;
    widget.draft.notes = _notes.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingStep3PaymentScreen(draft: widget.draft),
      ),
    );
  }

  DateTime _computeEnd() {
    final startMinutes = _start.hour * 60 + _start.minute;
    final endMinutes = startMinutes + (_duration * 60).toInt();
    final h = endMinutes ~/ 60;
    final m = endMinutes % 60;
    return DateTime(_date.year, _date.month, _date.day, h, m);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickStart() async {
    final picked = await showTimePicker(context: context, initialTime: _start);
    if (picked != null) setState(() => _start = picked);
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  String _fmtTimeOfDay(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  String _fmtTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  String _fmtTimeFromOfDay(TimeOfDay t) => _fmtTimeOfDay(t);
}
