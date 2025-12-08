import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/booking_draft.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/theme.dart';
import 'booking_step1_identity_screen.dart';

class FieldDetailScreen extends StatelessWidget {
  const FieldDetailScreen({super.key, required this.field});
  final PlayingField field;

  @override
  Widget build(BuildContext context) {
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Back to Courts',
                    style: BookingTextStyles.bodyLight.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF34D399), Color(0xFF16A34A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        if (field.imageUrl != null)
                          Positioned.fill(
                            child: Image.network(
                              field.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(field.name,
                    style: BookingTextStyles.display.copyWith(fontSize: 28)),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 18, color: BookingColors.textLight),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${field.address}, ${field.city}',
                        style: BookingTextStyles.bodyLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _infoCard(),
                const SizedBox(height: 16),
                if (field.amenities != null && field.amenities!.isNotEmpty)
                  _amenities(),
                if ((field.ownerContact != null && field.ownerContact!.isNotEmpty) ||
                    (field.ownerBankAccount != null &&
                        field.ownerBankAccount!.isNotEmpty))
                  const SizedBox(height: 16),
                _contact(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: BookingDecorations.primaryButton,
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
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      decoration: BookingDecorations.card,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Price per hour', style: BookingTextStyles.cardSubtitle),
              Text('Rp ${field.pricePerHour.toInt()}',
                  style: BookingTextStyles.price),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow('Surface', field.courtSurface),
          _infoRow(
              'Hours',
              '${field.openingTime ?? "-"} - '
              '${field.closingTime ?? "-"}'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: BookingTextStyles.cardSubtitle),
          Text(value, style: BookingTextStyles.body),
        ],
      ),
    );
  }

  Widget _amenities() {
    return Container(
      decoration: BookingDecorations.card,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amenities', style: BookingTextStyles.title.copyWith(fontSize: 18)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: field.amenities!
                .map((a) => Chip(
                      label: Text(
                        a.toString(),
                        style: BookingTextStyles.cardSubtitle.copyWith(
                          color: BookingColors.green700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      backgroundColor: BookingColors.green100,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _contact() {
    if ((field.ownerContact == null || field.ownerContact!.isEmpty) &&
        (field.ownerBankAccount == null || field.ownerBankAccount!.isEmpty)) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BookingDecorations.card,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Questions?', style: BookingTextStyles.title.copyWith(fontSize: 18)),
          if (field.ownerContact != null && field.ownerContact!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Contact the court at ${field.ownerContact}',
                style: BookingTextStyles.body),
          ],
          if (field.ownerBankAccount != null && field.ownerBankAccount!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('Bank: ${field.ownerBankAccount}',
                style: BookingTextStyles.cardSubtitle),
          ],
        ],
      ),
    );
  }
}
