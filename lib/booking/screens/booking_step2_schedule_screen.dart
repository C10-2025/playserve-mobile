import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/booking_draft.dart';
import 'package:playserve_mobile/booking/models/availability.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
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
      appBar: AppBar(title: const Text('Step 2: Schedule')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
              onPressed: _pickDate,
              child: Text('Date: ${_fmtDate(_date)}'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _pickStart,
              child: Text('Start: ${_fmtTimeFromOfDay(_start)}'),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [1.0, 1.5, 2.0, 2.5, 3.0, 4.0]
                  .map((d) => ChoiceChip(
                        label: Text('${d}h'),
                        selected: _duration == d,
                        onSelected: (_) => setState(() => _duration = d),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Text('End: ${_fmtTime(end)}'),
            const SizedBox(height: 8),
            TextField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (_checking) const LinearProgressIndicator(),
            if (_availability != null)
              Text(
                _availability!.message,
                style: TextStyle(
                    color: _availability!.available ? Colors.green : Colors.red),
              ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
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
                onPressed: _next,
                child: const Text('Next'),
              ),
            )
          ],
        ),
      ),
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
