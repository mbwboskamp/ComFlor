import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/router/route_guards.dart';

// Feature imports
import 'package:driversense_app/features/auth/presentation/pages/login_page.dart';
import 'package:driversense_app/features/auth/presentation/pages/two_factor_page.dart';
import 'package:driversense_app/features/auth/presentation/pages/consent_page.dart';
import 'package:driversense_app/features/home/presentation/pages/home_page.dart';
import 'package:driversense_app/features/check/presentation/pages/start_check_page.dart';
import 'package:driversense_app/features/check/presentation/pages/end_check_page.dart';
import 'package:driversense_app/features/tracking/presentation/pages/active_trip_page.dart';
import 'package:driversense_app/features/tracking/presentation/pages/trip_history_page.dart';
import 'package:driversense_app/features/tracking/presentation/pages/trip_detail_page.dart';
import 'package:driversense_app/features/incidents/presentation/pages/report_incident_page.dart';
import 'package:driversense_app/features/incidents/presentation/pages/incident_history_page.dart';
import 'package:driversense_app/features/chat/presentation/pages/chat_list_page.dart';
import 'package:driversense_app/features/chat/presentation/pages/conversation_page.dart';
import 'package:driversense_app/features/achievements/presentation/pages/achievements_page.dart';
import 'package:driversense_app/features/achievements/presentation/pages/goals_page.dart';
import 'package:driversense_app/features/settings/presentation/pages/settings_page.dart';
import 'package:driversense_app/features/settings/presentation/pages/privacy_zones_page.dart';
import 'package:driversense_app/features/settings/presentation/pages/notifications_page.dart';
import 'package:driversense_app/features/settings/presentation/pages/language_page.dart';

/// Application router configuration
@lazySingleton
class AppRouter {
  final AuthGuard _authGuard;

  AppRouter(this._authGuard);

  late final GoRouter config = GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    redirect: _authGuard.redirect,
    routes: [
      // Splash / initial loading
      GoRoute(
        path: Routes.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Auth routes
      GoRoute(
        path: Routes.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.twoFactor,
        name: RouteNames.twoFactor,
        builder: (context, state) {
          final sessionToken = state.extra as String?;
          return TwoFactorPage(sessionToken: sessionToken);
        },
      ),
      GoRoute(
        path: Routes.consent,
        name: RouteNames.consent,
        builder: (context, state) => const ConsentPage(),
      ),

      // Main app routes
      GoRoute(
        path: Routes.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),

      // Check routes
      GoRoute(
        path: Routes.startCheck,
        name: RouteNames.startCheck,
        builder: (context, state) => const StartCheckPage(),
      ),
      GoRoute(
        path: Routes.endCheck,
        name: RouteNames.endCheck,
        builder: (context, state) => const EndCheckPage(),
      ),

      // Trip / Tracking routes
      GoRoute(
        path: Routes.activeTrip,
        name: RouteNames.activeTrip,
        builder: (context, state) => const ActiveTripPage(),
      ),
      GoRoute(
        path: Routes.tripHistory,
        name: RouteNames.tripHistory,
        builder: (context, state) => const TripHistoryPage(),
      ),
      GoRoute(
        path: Routes.tripDetail,
        name: RouteNames.tripDetail,
        builder: (context, state) {
          final tripId = state.pathParameters['id']!;
          return TripDetailPage(tripId: tripId);
        },
      ),

      // Incident routes
      GoRoute(
        path: Routes.reportIncident,
        name: RouteNames.reportIncident,
        builder: (context, state) {
          final tripId = state.extra as String?;
          return ReportIncidentPage(tripId: tripId);
        },
      ),
      GoRoute(
        path: Routes.incidentHistory,
        name: RouteNames.incidentHistory,
        builder: (context, state) => const IncidentHistoryPage(),
      ),

      // Chat routes
      GoRoute(
        path: Routes.chatList,
        name: RouteNames.chatList,
        builder: (context, state) => const ChatListPage(),
      ),
      GoRoute(
        path: Routes.conversation,
        name: RouteNames.conversation,
        builder: (context, state) {
          final conversationId = state.pathParameters['id']!;
          return ConversationPage(conversationId: conversationId);
        },
      ),

      // Achievement routes
      GoRoute(
        path: Routes.achievements,
        name: RouteNames.achievements,
        builder: (context, state) => const AchievementsPage(),
      ),
      GoRoute(
        path: Routes.goals,
        name: RouteNames.goals,
        builder: (context, state) => const GoalsPage(),
      ),

      // Settings routes
      GoRoute(
        path: Routes.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: Routes.privacyZones,
        name: RouteNames.privacyZones,
        builder: (context, state) => const PrivacyZonesPage(),
      ),
      GoRoute(
        path: Routes.notifications,
        name: RouteNames.notifications,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: Routes.language,
        name: RouteNames.language,
        builder: (context, state) => const LanguagePage(),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
}

/// Splash page shown while loading
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Replace with actual logo
            const Icon(
              Icons.drive_eta,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Error page for routing errors
class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
