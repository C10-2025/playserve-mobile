import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/screens/field_detail_screen.dart';
import 'package:playserve_mobile/booking/widgets/booking_field_card.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/booking/theme.dart';
import '../services/booking_service.dart';
import '../config.dart';

class FieldListScreen extends StatelessWidget {
  const FieldListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final service = BookingService(request, baseUrl: kBaseUrl);

    return Scaffold(
      backgroundColor: BookingColors.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Container(
              decoration: BookingDecorations.panel,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Find Your', style: BookingTextStyles.display),
                  Text('Perfect Court',
                      style: BookingTextStyles.display.copyWith(color: BookingColors.lime)),
                  const SizedBox(height: 24),
                  FutureBuilder<List<PlayingField>>(
                    future: service.fetchFields(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: CircularProgressIndicator(color: BookingColors.lime)),
                        );
                      }
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text('Error: ${snapshot.error}',
                              style: BookingTextStyles.bodyLight),
                        );
                      }
                      final fields = snapshot.data ?? [];
                      if (fields.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text('No courts available.',
                              style: BookingTextStyles.bodyLight),
                        );
                      }
                      return _buildGrid(context, fields);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<PlayingField> fields) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth >= 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
        }
        return GridView.builder(
          padding: const EdgeInsets.only(top: 8),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
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
    );
  }
}
