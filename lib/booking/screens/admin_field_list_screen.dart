import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/booking/screens/admin_field_form_screen.dart';
import 'package:playserve_mobile/booking/services/booking_service.dart';
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
      appBar: AppBar(title: const Text('Admin: Courts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminFieldFormScreen()),
          );
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<PlayingField>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final fields = snapshot.data ?? [];
          if (fields.isEmpty) {
            return const Center(child: Text('No courts yet'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: fields.length,
              itemBuilder: (_, i) => AdminFieldTile(
                field: fields[i],
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminFieldFormScreen(field: fields[i]),
                    ),
                  );
                  _refresh();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
