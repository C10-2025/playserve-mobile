import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';

class BookingFieldCard extends StatelessWidget {
  const BookingFieldCard({super.key, required this.field, required this.onTap});

  final PlayingField field;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: field.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  field.imageUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                ),
              )
            : const Icon(Icons.sports_tennis),
        title: Text(field.name),
        subtitle: Text('${field.city} • Rp ${field.pricePerHour.toInt()}/hour'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
