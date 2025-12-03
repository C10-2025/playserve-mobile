import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/playing_field.dart';
import '../services/booking_service.dart';
import 'my_bookings_page.dart';

class FieldDetailPage extends StatefulWidget {
  const FieldDetailPage({super.key, required this.field});
  final PlayingFieldItem field;

  @override
  State<FieldDetailPage> createState() => _FieldDetailPageState();
}

class _FieldDetailPageState extends State<FieldDetailPage> {
  late BookingService service;
  final _bookerNameController = TextEditingController();
  final _bookerPhoneController = TextEditingController();
  final _bookerEmailController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  bool _isChecking = false;
  bool _isBooking = false;
  String? _availabilityMsg;
  bool? _available;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    service = BookingService(request);
  }

  String _fmtDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(context: context, initialTime: _startTime);
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(context: context, initialTime: _endTime);
    if (picked != null) setState(() => _endTime = picked);
  }

  Future<void> _checkAvailability() async {
    setState(() {
      _isChecking = true;
      _availabilityMsg = null;
      _available = null;
    });
    try {
      final resp = await service.checkAvailability(
        fieldId: int.parse(widget.field.id),
        date: _fmtDate(_selectedDate),
        startTime: _fmtTime(_startTime),
        endTime: _fmtTime(_endTime),
      );
      setState(() {
        _availabilityMsg = resp.message;
        _available = resp.available;
      });
    } catch (e) {
      setState(() {
        _availabilityMsg = e.toString();
        _available = false;
      });
    } finally {
      setState(() => _isChecking = false);
    }
  }

  Future<void> _book() async {
    if (!_formValid()) return;
    setState(() => _isBooking = true);
    try {
      await service.createBooking(
        fieldId: int.parse(widget.field.id),
        bookingDate: _fmtDate(_selectedDate),
        startTime: _fmtTime(_startTime),
        endTime: _fmtTime(_endTime),
        bookerName: _bookerNameController.text.trim(),
        bookerPhone: _bookerPhoneController.text.trim(),
        bookerEmail: _bookerEmailController.text.trim(),
        notes: _notesController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking created!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyBookingsPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book: $e')),
      );
    } finally {
      setState(() => _isBooking = false);
    }
  }

  bool _formValid() {
    if (_bookerNameController.text.trim().isEmpty ||
        _bookerPhoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and phone are required')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.field.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.field.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.field.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 180, color: Colors.grey[300]),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              widget.field.address,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              'City: ${widget.field.city.name.toUpperCase()} • Surface: ${widget.field.courtSurface.name.toUpperCase()}',
            ),
            const SizedBox(height: 6),
            Text('Price per hour: Rp${widget.field.pricePerHour.toInt()}'),
            const Divider(height: 24),
            const Text('Book this court', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPickers(),
            const SizedBox(height: 8),
            _buildTextField(_bookerNameController, 'Your name'),
            const SizedBox(height: 8),
            _buildTextField(_bookerPhoneController, 'Phone'),
            const SizedBox(height: 8),
            _buildTextField(_bookerEmailController, 'Email (optional)'),
            const SizedBox(height: 8),
            _buildTextField(_notesController, 'Notes (optional)', maxLines: 3),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isChecking ? null : _checkAvailability,
                  icon: _isChecking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: const Text('Check'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isBooking ? null : _book,
                  icon: _isBooking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: const Text('Book'),
                ),
              ],
            ),
            if (_availabilityMsg != null) ...[
              const SizedBox(height: 8),
              Text(
                _availabilityMsg!,
                style: TextStyle(
                  color: _available == true ? Colors.green : Colors.red,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _pickDate,
                child: Text('Date: ${_fmtDate(_selectedDate)}'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _pickStartTime,
                child: Text('Start: ${_fmtTime(_startTime)}'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: _pickEndTime,
                child: Text('End: ${_fmtTime(_endTime)}'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
