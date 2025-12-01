import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onChangeAvatar;

  const AvatarWidget({
    super.key,
    required this.imageUrl,
    required this.onChangeAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imageUrl),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB8D243),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onChangeAvatar,
          child: const Text(
            "CHANGE AVATAR",
            style: TextStyle(
              color: Color(0xFF0C1446),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
