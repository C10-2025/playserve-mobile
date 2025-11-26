import 'package:flutter/material.dart';
import '../models/community.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final VoidCallback? onJoin;

  const CommunityCard({
    super.key,
    required this.community,
    this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              community.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(community.description),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${community.membersCount} members'),
                ElevatedButton(
                  onPressed: onJoin,
                  child: Text(
                    community.isJoined ? 'Joined' : 'Join',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
