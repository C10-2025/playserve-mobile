import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/theme.dart';

class AdminFieldTile extends StatelessWidget {
  const AdminFieldTile({
    super.key,
    required this.field,
    required this.onTap,
    this.onDelete,
  });
  final PlayingField field;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BookingDecorations.card.copyWith(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(field.name, style: BookingTextStyles.cardTitle),
                      const SizedBox(height: 8),
                      Text(
                        '${field.city}',
                        style: BookingTextStyles.cardSubtitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Surface: ${field.courtSurface}',
                        style: BookingTextStyles.cardSubtitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${field.pricePerHour.toInt()}/hour',
                        style: BookingTextStyles.price.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: field.isActive
                          ? BookingColors.green100
                          : BookingColors.red100,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      field.isActive ? 'Active' : 'Inactive',
                      style: BookingTextStyles.cardSubtitle.copyWith(
                        color: field.isActive
                            ? BookingColors.green700
                            : BookingColors.red600,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (onDelete != null) ...[
                    const SizedBox(height: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                      tooltip: 'Delete Court',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
