import 'package:flutter/material.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController usernameController = TextEditingController(text: "@a");
  final TextEditingController instagramController = TextEditingController(text: "annisafakhirra");
  final TextEditingController locationController = TextEditingController(text: "Bogor");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1446),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1446),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "EDIT MY PROFILE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AvatarWidget(
                imageUrl: 'assets/avatar.png',
                onChangeAvatar: () {},
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "Username",
                hint: "@a",
                controller: usernameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Instagram",
                hint: "annisafakhirra",
                controller: instagramController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Location",
                hint: "Bogor",
                controller: locationController,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: "SAVE CHANGES",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Changes Saved!")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
