import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/screens/admin_field_form_screen.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
import 'package:playserve_mobile/booking/theme.dart';
import 'package:playserve_mobile/booking/widgets/admin_field_tile.dart';
import 'package:provider/provider.dart';
import '../config.dart';

class AdminFieldListScreen extends StatefulWidget {
  const AdminFieldListScreen({super.key});

  @override
  State<AdminFieldListScreen> createState() => _AdminFieldListScreenState();
}

class _AdminFieldListScreenState extends State<AdminFieldListScreen> {
  late BookingService service;
  late Future<List<PlayingField>> future;

  @override
  void initState() {
    super.initState();
    service = BookingService(context.read<CookieRequest>(), baseUrl: kBaseUrl);
    future = service.adminFetchFields();
  }

  Future<void> _refresh() async {
    setState(() {
      future = service.adminFetchFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookingColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: BookingColors.lime,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminFieldFormScreen()),
          );
          _refresh();
        },
        child: const Icon(Icons.add, color: BookingColors.navbarBlue),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BookingDecorations.panel,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Court Management',
                    style: BookingTextStyles.display.copyWith(fontSize: 28)),
                const SizedBox(height: 20),
                FutureBuilder<List<PlayingField>>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                            child: CircularProgressIndicator(color: BookingColors.lime)),
                      );
                    }
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text('Error: ${snapshot.error}',
                            style: BookingTextStyles.bodyLight),
                      );
                    }
                    final fields = snapshot.data ?? [];
                    if (fields.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text('No courts yet', style: BookingTextStyles.bodyLight),
                      );
                    }
                    return Column(
                      children: fields
                          .map((f) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: AdminFieldTile(
                                  field: f,
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AdminFieldFormScreen(field: f),
                                      ),
                                    );
                                    _refresh();
                                  },
                                ),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
