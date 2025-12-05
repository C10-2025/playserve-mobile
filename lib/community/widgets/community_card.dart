import 'package:flutter/material.dart';
import '../models/community.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final VoidCallback? onTap;                // buka detail
  final Future<void> Function()? onJoin;    // join komunitas

  const CommunityCard({
    super.key,
    required this.community,
    this.onTap,
    this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final bool joined = community.isJoined;

    return InkWell(
      // card hanya bisa di-tap kalau sudah join
      onTap: joined && onTap != null ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 4),
              color: Colors.black12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              community.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${community.membersCount} members',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            if (community.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                community.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
              ),
            ],
            const Spacer(),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (joined) {
                    // sudah join → buka detail
                    if (onTap != null) onTap!();
                  } else {
                    // belum join → panggil join
                    if (onJoin != null) await onJoin!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      joined ? Colors.grey[300] : const Color(0xFFC1D752),
                  foregroundColor:
                      joined ? Colors.grey[800] : const Color(0xFF082459),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  joined ? 'OPEN COMMUNITY' : 'JOIN NOW',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
