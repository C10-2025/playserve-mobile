import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';

class AdminFieldTile extends StatelessWidget {
  const AdminFieldTile({super.key, required this.field, required this.onTap});
  final PlayingField field;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(field.name),
        subtitle: Text('${field.city} • ${field.isActive ? "Active" : "Inactive"}'),
        onTap: onTap,
      ),
    );
  }
}
