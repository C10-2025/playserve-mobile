import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/booking_draft.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'booking_step1_identity_screen.dart';

class FieldDetailScreen extends StatelessWidget {
  const FieldDetailScreen({super.key, required this.field});
  final PlayingField field;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(field.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (field.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(field.imageUrl!,
                    height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 12),
            Text(field.address, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 6),
            Text('City: ${field.city} • Surface: ${field.courtSurface}'),
            const SizedBox(height: 6),
            Text('Hours: ${field.openingTime ?? "-"} - ${field.closingTime ?? "-"}'),
            const SizedBox(height: 6),
            Text('Price: Rp ${field.pricePerHour.toInt()}/hour',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (field.amenities != null && field.amenities!.isNotEmpty)
              Wrap(
                spacing: 8,
                children: field.amenities!
                    .map((a) => Chip(label: Text(a.toString())))
                    .toList(),
              ),
            const SizedBox(height: 12),
            if (field.ownerContact != null && field.ownerContact!.isNotEmpty)
              Text('Contact: ${field.ownerContact}'),
            if (field.ownerBankAccount != null &&
                field.ownerBankAccount!.isNotEmpty)
              Text('Bank: ${field.ownerBankAccount}'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final draft = BookingDraft(field: field);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingStep1IdentityScreen(draft: draft),
                    ),
                  );
                },
                child: const Text('BOOK NOW'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
