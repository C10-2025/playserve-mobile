import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/booking_draft.dart';
import 'package:playserve_mobile/booking/theme.dart';
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
                          _progress(step: 1),
                          const SizedBox(height: 24),
                          Text(
                            'Your Information',
                            style: BookingTextStyles.title,
                          ),
                          const SizedBox(height: 12),
                          _input(_name, 'Full name', required: true),
                          const SizedBox(height: 12),
                          _input(_phone, 'Phone number', required: true),
                          const SizedBox(height: 12),
                          _input(_email, 'Email (optional)'),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: BookingDecorations.primaryButton,
                              onPressed: _next,
                              child: const Text('Next: Select Time'),
                            ),
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

  Widget _input(
    TextEditingController c,
    String label, {
    bool required = false,
  }) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        labelStyle: BookingTextStyles.cardSubtitle,
        filled: true,
        fillColor: BookingColors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: BookingColors.green600, width: 2),
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

    Widget connector(bool active) => Expanded(
      child: Container(
        height: 2,
        color: active ? BookingColors.gray200 : BookingColors.gray200,
      ),
    );

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
        connector(true),
        Expanded(
          child: Column(
            children: [
              circle(2, step >= 2),
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
        connector(true),
        Expanded(
          child: Column(
            children: [
              circle(3, step >= 3),
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

  void _next() {
    if (_name.text.trim().isEmpty || _phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name and phone required')));
      return;
    }

    final phoneRegex = RegExp(r'^(0|\+62)\d{9,14}$');
    if (!phoneRegex.hasMatch(_phone.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid phone number format. Must start with 0 or +62 and be 10-15 digits.',
          ),
        ),
      );
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
