import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:playserve_mobile/review/screens/review_page.dart';

void main() {
  runApp(
    Provider<CookieRequest>(
      create: (_) => CookieRequest(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlayServe',
      debugShowCheckedModeBanner: false,
      home: const ReviewPage(),
    );
  }
}
