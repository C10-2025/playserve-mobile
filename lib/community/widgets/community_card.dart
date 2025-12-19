import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/community.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final VoidCallback? onTap;
  final Future<void> Function()? onJoin;
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14), // 🔽 sedikit lebih kecil
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
            // ================= TOP (FLEXIBLE) =================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME
                  Text(
                    community.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // MEMBERS
                  Text(
                    '${community.membersCount} members',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),

                  // DESCRIPTION
                  if (community.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      community.description,
                      maxLines: 2, // 🔽 dari 3 → 2
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[800],
                        height: 1.3,
                      ),
                    ),
                  ],

                  // CREATED BY
                  if (showCreatorInfo &&
                      community.creatorUsername != null &&
                      community.creatorUsername!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Created by: ${community.creatorUsername}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ================= BOTTOM (FIXED) =================
            if (isCreator)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // BADGE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC1D752),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'You are the creator',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // OPEN
                  if (onTap != null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 6),
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
                  const SizedBox(height: 6),

                  // EDIT + DELETE
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC1D752),
                            foregroundColor: const Color(0xFF111827),
                            padding:
                                const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text(
                            'Edit',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (onDelete != null) await onDelete!();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[500],
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text(
                            'Delete',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: joined ? onTap : () async {
                    if (onJoin != null) await onJoin!();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        joined ? Colors.grey[300] : const Color(0xFFC1D752),
                    foregroundColor:
                        joined ? Colors.grey[800] : const Color(0xFF082459),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    textStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text(
                    joined ? 'OPEN COMMUNITY' : 'JOIN NOW',
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
