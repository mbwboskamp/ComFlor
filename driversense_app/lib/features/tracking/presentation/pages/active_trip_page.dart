import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/shared/widgets/buttons/primary_button.dart';
import 'package:driversense_app/shared/widgets/buttons/panic_button.dart';
import 'package:driversense_app/features/tracking/presentation/bloc/tracking_bloc.dart';

/// Active trip page showing current trip with map, stats, and controls
class ActiveTripPage extends StatefulWidget {
  const ActiveTripPage({super.key});

  @override
  State<ActiveTripPage> createState() => _ActiveTripPageState();
}

class _ActiveTripPageState extends State<ActiveTripPage> {
  // Mock trip data
  final Map<String, dynamic> _tripData = {
    'vehicleName': 'Vrachtwagen 01',
    'vehiclePlate': 'AB-123-CD',
    'startTime': DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
    'distance': 87.5,
    'currentSpeed': 65,
    'averageSpeed': 58,
    'startKm': 125000,
  };

  String get _duration {
    final start = _tripData['startTime'] as DateTime;
    final duration = DateTime.now().difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}u ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map placeholder
          _buildMapPlaceholder(),

          // Top bar with trip info
          _buildTopBar(),

          // Bottom panel with stats and controls
          _buildBottomPanel(),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Kaart wordt hier getoond',
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'GPS tracking actief',
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + AppSpacing.sm,
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tripData['vehicleName'] as String,
                              style: context.textTheme.titleSmall,
                            ),
                            Text(
                              context.l10n.tripActive,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _duration,
                        style: context.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: AppSpacing.borderRadiusFull,
                  ),
                ),

                // Stats grid
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.speed,
                        label: 'Snelheid',
                        value: '${_tripData['currentSpeed']} km/u',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.straighten,
                        label: 'Afstand',
                        value: '${_tripData['distance']} km',
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.timer_outlined,
                        label: 'Rijtijd',
                        value: _duration,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.trending_up,
                        label: 'Gem. snelheid',
                        value: '${_tripData['averageSpeed']} km/u',
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.push(Routes.reportIncident),
                        icon: const Icon(Icons.warning_amber),
                        label: Text(context.l10n.reportIncident),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        onPressed: () => _showEndTripDialog(),
                        text: context.l10n.endTrip,
                        backgroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Panic button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.panicButton,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    PanicButton(
                      onPressed: () => _showPanicConfirmation(),
                      size: PanicButtonSize.small,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEndTripDialog() async {
    final confirmed = await context.showConfirmDialog(
      title: context.l10n.endTrip,
      message: 'Weet je zeker dat je de rit wilt beeindigen?',
      confirmText: context.l10n.endTrip,
      cancelText: context.l10n.cancel,
    );

    if (confirmed && mounted) {
      context.push(Routes.endCheck);
    }
  }

  Future<void> _showPanicConfirmation() async {
    final confirmed = await context.showConfirmDialog(
      title: context.l10n.panicButton,
      message: context.l10n.panicConfirm,
      confirmText: context.l10n.send,
      cancelText: context.l10n.cancel,
      isDangerous: true,
    );

    if (confirmed && mounted) {
      context.showSnackBar(context.l10n.locationShared);
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPaddingCompact,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  ),
                  Text(
                    value,
                    style: context.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
