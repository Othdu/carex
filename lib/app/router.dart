import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../features/splash/view/splash_page.dart';
import '../features/onboarding/view/onboarding_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Home — coming soon')),
      ),
    ),
  ],
);
