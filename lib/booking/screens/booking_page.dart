import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/playing_field.dart';
import '../services/booking_service.dart';
import 'field_detail_page.dart';
import 'my_bookings_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late BookingService service;
  late Future<List<PlayingFieldItem>> _future;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    service = BookingService(request);
    _future = service.fetchFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyBookingsPage()),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<PlayingFieldItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final fields = snapshot.data ?? [];
          if (fields.isEmpty) {
            return const Center(child: Text('No fields available.'));
          }
          return ListView.builder(
            itemCount: fields.length,
            itemBuilder: (context, index) {
              final f = fields[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: f.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            f.imageUrl!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        )
                      : const Icon(Icons.sports_tennis),
                  title: Text(f.name),
                  subtitle: Text('${f.city.name.toUpperCase()} • Rp${f.pricePerHour.toInt()}/hour'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FieldDetailPage(field: f),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
