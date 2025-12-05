import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
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
    final service = BookingService(context.read<CookieRequest>(), baseUrl: kBaseUrl);
    final isEdit = widget.field != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Court' : 'Add Court')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _textField(_name, 'Name'),
              _textField(_address, 'Address'),
              _textField(_city, 'City'),
              _textField(_surface, 'Surface'),
              _textField(_price, 'Price per hour', keyboardType: TextInputType.number),
              _textField(_opening, 'Opening time (HH:MM)'),
              _textField(_closing, 'Closing time (HH:MM)'),
              _textField(_ownerName, 'Owner name'),
              _textField(_ownerPhone, 'Owner phone'),
              _textField(_ownerBank, 'Owner bank account'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
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
                              await service.adminUpdateField(widget.field!.id, payload);
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
                          width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
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
                            await service.adminDeleteField(widget.field!.id);
                            if (mounted) Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Delete failed: $e')));
                          } finally {
                            setState(() => _saving = false);
                          }
                        },
                  child: const Text('Deactivate'),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController c, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: keyboardType,
        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
