import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:driversense_app/features/tracking/presentation/bloc/tracking_bloc.dart';
import 'package:driversense_app/shared/widgets/buttons/primary_button.dart';
import 'package:driversense_app/shared/widgets/buttons/secondary_button.dart';
import 'package:driversense_app/shared/widgets/buttons/panic_button.dart';

/// Home page - main dashboard for drivers
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.appTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.chat_outlined),
                onPressed: () => context.push(Routes.chatList),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push(Routes.settings),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome message
                  _WelcomeCard(userName: authState.user.firstName),

                  const SizedBox(height: AppSpacing.lg),

                  // Active trip banner (if tracking)
                  BlocBuilder<TrackingBloc, TrackingState>(
                    builder: (context, trackingState) {
                      if (trackingState.isTracking) {
                        return _ActiveTripBanner(
                          onTap: () => context.push(Routes.activeTrip),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Quick actions
                  Text(
                    context.l10n.quickActions,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.play_circle_outline,
                          title: context.l10n.startCheck,
                          color: Colors.green,
                          onTap: () => context.push(Routes.startCheck),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.stop_circle_outlined,
                          title: context.l10n.endCheck,
                          color: Colors.red,
                          onTap: () => context.push(Routes.endCheck),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.warning_amber_outlined,
                          title: context.l10n.reportIncident,
                          color: Colors.orange,
                          onTap: () => context.push(Routes.reportIncident),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.history_outlined,
                          title: context.l10n.trips,
                          color: Colors.blue,
                          onTap: () => context.push(Routes.tripHistory),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Streak widget
                  _StreakCard(
                    currentStreak: 7,
                    onTap: () => context.push(Routes.achievements),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Recent activity
                  Text(
                    context.l10n.recentActivity,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _RecentActivityList(),

                  const SizedBox(height: AppSpacing.xxl),

                  // Panic button (centered, prominent)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          context.l10n.panicButton,
                          style: context.textTheme.labelLarge,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        PanicButton(
                          onPressed: () => _showPanicConfirmation(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: context.l10n.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.route_outlined),
                activeIcon: const Icon(Icons.route),
                label: context.l10n.trips,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.emoji_events_outlined),
                activeIcon: const Icon(Icons.emoji_events),
                label: context.l10n.achievements,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: context.l10n.profile,
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  // Already on home
                  break;
                case 1:
                  context.push(Routes.tripHistory);
                  break;
                case 2:
                  context.push(Routes.achievements);
                  break;
                case 3:
                  context.push(Routes.settings);
                  break;
              }
            },
          ),
        );
      },
    );
  }

  void _showPanicConfirmation(BuildContext context) async {
    final confirmed = await context.showConfirmDialog(
      title: context.l10n.panicButton,
      message: context.l10n.panicConfirm,
      confirmText: context.l10n.send,
      cancelText: context.l10n.cancel,
      isDangerous: true,
    );

    if (confirmed) {
      // TODO: Send panic alert
      context.showSnackBar(context.l10n.locationShared);
    }
  }
}

class _WelcomeCard extends StatelessWidget {
  final String userName;

  const _WelcomeCard({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.welcomeBack(userName),
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Klaar voor een veilige rit?',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveTripBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _ActiveTripBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.primaryContainer,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusMd,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_car,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.tripActive,
                      style: context.textTheme.titleSmall,
                    ),
                    Text(
                      'Tap om details te zien',
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusMd,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: context.textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int currentStreak;
  final VoidCallback onTap;

  const _StreakCard({
    required this.currentStreak,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusMd,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '🔥',
                  style: TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.currentStreak(currentStreak),
                      style: context.textTheme.titleMedium,
                    ),
                    Text(
                      'Ga zo door!',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock data
    final activities = [
      _ActivityItem(
        icon: Icons.check_circle,
        title: 'Start check voltooid',
        subtitle: 'Vandaag, 08:30',
        color: Colors.green,
      ),
      _ActivityItem(
        icon: Icons.route,
        title: 'Rit voltooid',
        subtitle: 'Gisteren, 17:45',
        color: Colors.blue,
      ),
      _ActivityItem(
        icon: Icons.emoji_events,
        title: 'Badge verdiend: Veilige Chauffeur',
        subtitle: 'Gisteren, 17:45',
        color: Colors.orange,
      ),
    ];

    return Card(
      child: Column(
        children: activities
            .map((activity) => ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: activity.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(activity.icon, color: activity.color, size: 20),
                  ),
                  title: Text(activity.title),
                  subtitle: Text(activity.subtitle),
                ))
            .toList(),
      ),
    );
  }
}

class _ActivityItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
