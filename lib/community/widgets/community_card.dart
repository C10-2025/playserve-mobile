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

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: EdgeInsets.all(s(12)), // dari 14
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          // ================= CONTENT =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  community.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: s(15), // dari 17
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: s(4)),
                Text(
                  '${community.membersCount} members',
                  style: GoogleFonts.inter(
                    fontSize: s(11),
                    color: Colors.grey[600],
                  ),
                ),
                if (community.description.isNotEmpty) ...[
                  SizedBox(height: s(6)),
                  Text(
                    community.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: s(11),
                      color: Colors.grey[800],
                      height: 1.25,
                    ),
                  ),
                ],
                if (showCreatorInfo &&
                    community.creatorUsername != null &&
                    community.creatorUsername!.isNotEmpty) ...[
                  SizedBox(height: s(4)),
                  Text(
                    'Created by: ${community.creatorUsername}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: s(10),
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: s(8)),

          // ================= BUTTON =================
          SizedBox(
            width: double.infinity,
            height: s(36), // penting: biar ga gendut
            child: ElevatedButton(
              onPressed: isCreator
                  ? (onTap ?? null)
                  : (joined ? (onTap ?? null) : () async {
                      if (onJoin != null) await onJoin!();
                    }),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    joined ? Colors.grey[300] : const Color(0xFFC1D752),
                foregroundColor:
                    joined ? Colors.grey[800] : const Color(0xFF082459),
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
          ),
        ],
      ),
    ),
  );
}
}
