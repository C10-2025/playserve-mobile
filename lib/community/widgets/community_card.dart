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
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 420;

    double s(double v) => isMobile ? v * 0.9 : v;

    final bool joined = community.isJoined;
    final bool isCreator = community.isCreator;

    // Tombol utama (non-creator): JOIN / OPEN
    Widget buildJoinOrOpenButton() {
      return SizedBox(
        width: double.infinity,
        height: s(36),
        child: ElevatedButton(
          onPressed: joined
              ? onTap
              : () async {
                  if (onJoin != null) await onJoin!();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: joined ? Colors.grey[300] : const Color(0xFFC1D752),
            foregroundColor: joined ? Colors.grey[800] : const Color(0xFF082459),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            textStyle: GoogleFonts.inter(
              fontSize: s(12),
              fontWeight: FontWeight.w700,
            ),
          ),
          child: Text(
            joined ? 'OPEN COMMUNITY' : 'JOIN NOW',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    // Action creator: OPEN (outlined) + Edit/Delete
    Widget buildCreatorActions() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onTap != null) ...[
            SizedBox(
              width: double.infinity,
              height: s(34),
              child: OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(
                    color: const Color(0xFF111827).withOpacity(0.15),
                  ),
                  foregroundColor: const Color(0xFF111827),
                  textStyle: GoogleFonts.inter(
                    fontSize: s(11),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text(
                  'OPEN COMMUNITY',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(height: s(8)),
          ],
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: s(36),
                  child: ElevatedButton(
                    onPressed: onEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC1D752),
                      foregroundColor: const Color(0xFF111827),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: s(12),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              SizedBox(width: s(8)),
              Expanded(
                child: SizedBox(
                  height: s(36),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (onDelete != null) await onDelete!();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[500],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: s(12),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Badge kecil: You are the creator (dipindah di bawah Created by)
    Widget buildCreatorBadge() {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: s(10),
          vertical: s(4),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFC1D752),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          'You are the creator',
          style: GoogleFonts.inter(
            fontSize: s(10.5),
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap, // biar bisa open kalau joined/creator dari tap card juga
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(s(14)),
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
            // ================= TOP CONTENT =================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: s(16),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF111827),
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: s(4)),
                  Text(
                    '${community.membersCount} members',
                    style: GoogleFonts.inter(
                      fontSize: s(12),
                      color: Colors.grey[600],
                    ),
                  ),
                  if (community.description.isNotEmpty) ...[
                    SizedBox(height: s(8)),
                    Text(
                      community.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: s(12),
                        color: Colors.grey[800],
                        height: 1.25,
                      ),
                    ),
                  ],

                  // Created by + badge creator DIPINDAH KE SINI
                  if (showCreatorInfo &&
                      community.creatorUsername != null &&
                      community.creatorUsername!.isNotEmpty) ...[
                    SizedBox(height: s(8)),
                    Text(
                      'Created by: ${community.creatorUsername}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: s(11),
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (isCreator) ...[
                      SizedBox(height: s(6)),
                      buildCreatorBadge(),
                    ],
                  ],
                ],
              ),
            ),

            SizedBox(height: s(10)),

            // ================= BOTTOM ACTIONS =================
            if (isCreator)
              buildCreatorActions()
            else
              buildJoinOrOpenButton(),
          ],
        ),
      ),
    );
  }
}
