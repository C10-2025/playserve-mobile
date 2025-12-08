import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/community.dart';

class CommunityCard extends StatelessWidget {
  final Community community;

  /// buka detail community
  final VoidCallback? onTap;

  /// join komunitas
  final Future<void> Function()? onJoin;

  /// edit community (hanya untuk creator)
  final VoidCallback? onEdit;

  /// delete community (hanya untuk creator)
  final Future<void> Function()? onDelete;

  /// kalau true → tampilkan "Created by: ..." (mirip Django: hanya admin yg lihat)
  final bool showCreatorInfo;

  const CommunityCard({
    super.key,
    required this.community,
    this.onTap,
    this.onJoin,
    this.onEdit,
    this.onDelete,
    this.showCreatorInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool joined = community.isJoined;
    final bool isCreator = community.isCreator;

    // ⬇️ ini kunci perbaikan
    final bool canOpenFromCard = (joined || isCreator) && onTap != null;

    return InkWell(
    onTap: onTap,
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
            // NAMA COMMUNITY
            Text(
              community.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),

            // JUMLAH MEMBER
            Text(
              '${community.membersCount} members',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),

            // DESKRIPSI (MAX 3 LINE)
            if (community.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                community.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[800],
                  height: 1.3,
                ),
              ),
            ],

            // "Created by: ..." → hanya kalau admin & ada username
            // dan BUKAN untuk card yang dimiliki creator sendiri (biar nggak redundant)
            if (showCreatorInfo &&
              community.creatorUsername != null &&
              community.creatorUsername!.isNotEmpty) ...[


              const SizedBox(height: 6),
              Text(
                'Created by: ${community.creatorUsername}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],

            const Spacer(),
            const SizedBox(height: 12),

            // === BAGIAN BAWAH: ACTIONS ===
            if (isCreator)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Badge "You are the creator"
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC1D752),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'You are the creator',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tombol OPEN COMMUNITY full width
                  if (onTap != null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: const Color(0xFF111827).withOpacity(0.15),
                          ),
                          foregroundColor: const Color(0xFF111827),
                          textStyle: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text(
                          'OPEN COMMUNITY',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Edit + Delete
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC1D752),
                            foregroundColor: const Color(0xFF111827),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (onDelete != null) {
                              await onDelete!();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[500],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ],
              )

            else if (joined)
              // SUDAH JOIN → OPEN COMMUNITY
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  child: const Text(
                    'OPEN COMMUNITY',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            else
              // BELUM JOIN → JOIN NOW
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (onJoin != null) await onJoin!();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC1D752),
                    foregroundColor: const Color(0xFF082459),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  child: const Text(
                    'JOIN NOW',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
