import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/profil/screens/login.dart';

void main() {
  runApp(const PlayServeApp());
}

class PlayServeApp extends StatelessWidget {
  const PlayServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PlayServe Login',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo,
          ).copyWith(secondary: const Color(0xFFB8D243)),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
