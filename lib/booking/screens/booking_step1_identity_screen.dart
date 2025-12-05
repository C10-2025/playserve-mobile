import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/booking_draft.dart';
import 'booking_step2_schedule_screen.dart';

class BookingStep1IdentityScreen extends StatefulWidget {
  const BookingStep1IdentityScreen({super.key, required this.draft});
  final BookingDraft draft;

  @override
  State<BookingStep1IdentityScreen> createState() =>
      _BookingStep1IdentityScreenState();
}

class _BookingStep1IdentityScreenState
    extends State<BookingStep1IdentityScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 1: Your Info')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _input(_name, 'Full name', required: true),
            const SizedBox(height: 12),
            _input(_phone, 'Phone number', required: true),
            const SizedBox(height: 12),
            _input(_email, 'Email (optional)'),
            const Spacer(),
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

  Widget _input(TextEditingController c, String label, {bool required = false}) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _next() {
    if (_name.text.trim().isEmpty || _phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Name and phone required')));
      return;
    }
    widget.draft.bookerName = _name.text.trim();
    widget.draft.bookerPhone = _phone.text.trim();
    widget.draft.bookerEmail = _email.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingStep2ScheduleScreen(draft: widget.draft),
      ),
    );
  }
}
