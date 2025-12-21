import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/theme.dart';

class BookingFieldCard extends StatelessWidget {
  const BookingFieldCard({super.key, required this.field, required this.onTap});

  final PlayingField field;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final price = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(field.pricePerHour);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          decoration: BookingDecorations.card,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              ClipRect(
                // Clip any content that overflows the card boundaries
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    8,
                  ), // Small bottom padding to reduce gap but keep cards tight
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field.name,
                        style: BookingTextStyles.cardTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: BookingColors.gray600,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${field.city}, ${field.address}',
                              style: BookingTextStyles.cardSubtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(price, style: BookingTextStyles.price),
                          Text(
                            'per hour',
                            style: BookingTextStyles.cardSubtitle.copyWith(
                              color: BookingColors.gray500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ), // Reduced from 14 to 12 for better spacing
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: BookingDecorations.primaryButton,
                          onPressed: onTap,
                          child: const Text('BOOK NOW'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final badges = <Widget>[];
    if (field.hasLights) {
      badges.add(const _LightsBadge());
    }
    if (field.hasBackboard) {
      badges.add(const _BackboardBadge());
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: SizedBox(
        height: 192,
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
                  errorBuilder: (context, _, __) {
                    return Image.network(
                      "https://images.unsplash.com/photo-1547934045-2942d193cb49",
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            if (badges.isNotEmpty)
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: badges,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LightsBadge extends StatelessWidget {
  const _LightsBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.yellow[600],
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        '💡 Lights',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _BackboardBadge extends StatelessWidget {
  const _BackboardBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4E6), // Light rose/pink
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        '🏓 Backboard',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
