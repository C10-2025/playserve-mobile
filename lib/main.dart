import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'community/screen/community_landing_page.dart';
import 'community/screen/my_communities_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'SoccerID Community',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff082459)),
          useMaterial3: true,
        ),
        home: const CommunityLandingPage(),
        routes: {
          '/my-communities': (context) => const MyCommunitiesPage(),
        },
      ),
    );
  }
}