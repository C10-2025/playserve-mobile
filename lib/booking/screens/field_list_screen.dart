import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/screens/field_detail_screen.dart';
import 'package:playserve_mobile/booking/widgets/booking_field_card.dart';
import 'package:provider/provider.dart';
import '../services/booking_service.dart';
import '../config.dart';

class FieldListScreen extends StatelessWidget {
  const FieldListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final service = BookingService(request, baseUrl: kBaseUrl);

    return Scaffold(
      appBar: AppBar(title: const Text('Courts')),
      body: FutureBuilder<List<PlayingField>>(
        future: service.fetchFields(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final fields = snapshot.data ?? [];
          if (fields.isEmpty) {
            return const Center(child: Text('No courts available.'));
          }
          return ListView.builder(
            itemCount: fields.length,
            itemBuilder: (_, i) {
              final field = fields[i];
              return BookingFieldCard(
                field: field,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FieldDetailScreen(field: field),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
