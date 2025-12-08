import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:playserve_mobile/booking/theme.dart';
import 'package:playserve_mobile/main_navbar_admin.dart';
import 'package:provider/provider.dart';
import '../config.dart';

class AdminFieldFormScreen extends StatefulWidget {
  const AdminFieldFormScreen({super.key, this.field});
  final PlayingField? field;

  @override
  State<AdminFieldFormScreen> createState() => _AdminFieldFormScreenState();
}

class _AdminFieldFormScreenState extends State<AdminFieldFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _surface = TextEditingController();
  final _price = TextEditingController();
  final _opening = TextEditingController();
  final _closing = TextEditingController();
  final _ownerName = TextEditingController();
  final _ownerPhone = TextEditingController();
  final _ownerBank = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.field != null) {
      _name.text = widget.field!.name;
      _address.text = widget.field!.address;
      _city.text = widget.field!.city;
      _surface.text = widget.field!.courtSurface;
      _price.text = widget.field!.pricePerHour.toString();
      _opening.text = widget.field!.openingTime ?? '';
      _closing.text = widget.field!.closingTime ?? '';
      _ownerName.text = widget.field!.ownerName ?? '';
      _ownerPhone.text = widget.field!.ownerContact ?? '';
      _ownerBank.text = widget.field!.ownerBankAccount ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = BookingService(
      context.read<CookieRequest>(),
      baseUrl: kBaseUrl,
    );
    final isEdit = widget.field != null;
    return Scaffold(
      backgroundColor: BookingColors.background,
      appBar: AppBar(
        backgroundColor: BookingColors.navbarBlue,
        foregroundColor: Colors.white,
        title: Text(isEdit ? 'Edit Court' : 'Add Court'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BookingDecorations.panel,
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? 'Edit Court' : 'Add New Court',
                    style: BookingTextStyles.display.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 20),
                  _section(
                    title: 'Basic Information',
                    children: [
                      _textField(_name, 'Court Name'),
                      _textField(_address, 'Full Address'),
                      _textField(_city, 'City'),
                    ],
                  ),
                  _section(
                    title: 'Court Details',
                    children: [
                      _textField(_surface, 'Court Surface'),
                      _textField(
                        _price,
                        'Price per hour',
                        keyboardType: TextInputType.number,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _textField(_opening, 'Opening time (HH:MM)'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _textField(_closing, 'Closing time (HH:MM)'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _section(
                    title: 'Owner Information',
                    children: [
                      _textField(_ownerName, 'Owner Name'),
                      _textField(_ownerPhone, 'Owner Contact'),
                      _textField(_ownerBank, 'Bank Account Details'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: BookingDecorations.primaryButton,
                      onPressed: _saving
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() => _saving = true);
                              final payload = {
                                "name": _name.text,
                                "address": _address.text,
                                "city": _city.text,
                                "court_surface": _surface.text,
                                "price_per_hour": _price.text,
                                "opening_time": _opening.text,
                                "closing_time": _closing.text,
                                "owner_name": _ownerName.text,
                                "owner_contact": _ownerPhone.text,
                                "owner_bank_account": _ownerBank.text,
                              };
                              try {
                                if (isEdit) {
                                  await service.adminUpdateField(
                                    widget.field!.id,
                                    payload,
                                  );
                                } else {
                                  await service.adminCreateField(payload);
                                }
                                if (!mounted) return;
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              } finally {
                                setState(() => _saving = false);
                              }
                            },
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(isEdit ? 'Save' : 'Create'),
                    ),
                  ),
                  if (isEdit)
                    TextButton(
                      onPressed: _saving
                          ? null
                          : () async {
                              setState(() => _saving = true);
                              try {
                                await service.adminDeleteField(
                                  widget.field!.id,
                                );
                                if (mounted) Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Delete failed: $e')),
                                );
                              } finally {
                                setState(() => _saving = false);
                              }
                            },
                      child: const Text('Deactivate'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MainNavbarAdmin(currentIndex: -1),
    );
  }

  Widget _textField(
    TextEditingController c,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: keyboardType,
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
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

  Widget _section({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BookingDecorations.card,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: BookingTextStyles.title.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            ...children.expand((w) => [w, const SizedBox(height: 12)]).toList()
              ..removeLast(),
          ],
        ),
      ),
    );
  }

}
