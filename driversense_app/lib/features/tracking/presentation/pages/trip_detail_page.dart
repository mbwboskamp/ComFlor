import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';

/// Trip detail page showing trip information and route map
class TripDetailPage extends StatelessWidget {
  final String tripId;

  const TripDetailPage({
    super.key,
    required this.tripId,
  });

  // Mock trip data
  Map<String, dynamic> get _tripData => {
    'id': tripId,
    'date': DateTime.now().subtract(const Duration(hours: 2)),
    'vehicleName': 'Vrachtwagen 01',
    'vehiclePlate': 'AB-123-CD',
    'driverName': 'Jan de Vries',
    'distance': 87.5,
    'duration': '2u 30m',
    'startTime': '08:30',
    'endTime': '11:00',
    'startLocation': 'Amsterdam',
    'endLocation': 'Rotterdam',
    'startKm': 125000,
    'endKm': 125088,
    'averageSpeed': 58,
    'maxSpeed': 82,
    'fuelUsed': 15.2,
    'startMood': 'Goed',
    'endMood': 'Neutraal',
    'incidents': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with map
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildMapPlaceholder(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: Share trip
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showOptionsMenu(context),
              ),
            ],
          ),

          // Trip details
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and date
                  _buildHeader(context),

                  const SizedBox(height: AppSpacing.lg),

                  // Route info
                  _buildRouteCard(context),

                  const SizedBox(height: AppSpacing.md),

                  // Stats grid
                  _buildStatsGrid(context),

                  const SizedBox(height: AppSpacing.md),

                  // Vehicle info
                  _buildVehicleCard(context),

                  const SizedBox(height: AppSpacing.md),

                  // Mood tracking
                  _buildMoodCard(context),

                  const SizedBox(height: AppSpacing.md),

                  // Incidents section
                  _buildIncidentsSection(context),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Route kaart',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Overlay gradient for better text visibility
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final date = _tripData['date'] as DateTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_tripData['startLocation']} - ${_tripData['endLocation']}',
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${date.day}-${date.month}-${date.year} | ${_tripData['startTime']} - ${_tripData['endTime']}',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildRouteCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 40,
                      color: context.colorScheme.outline.withOpacity(0.3),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RoutePoint(
                        location: _tripData['startLocation'] as String,
                        time: _tripData['startTime'] as String,
                        km: '${_tripData['startKm']} km',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _RoutePoint(
                        location: _tripData['endLocation'] as String,
                        time: _tripData['endTime'] as String,
                        km: '${_tripData['endKm']} km',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.straighten,
            label: 'Afstand',
            value: '${_tripData['distance']} km',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.timer_outlined,
            label: 'Duur',
            value: _tripData['duration'] as String,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voertuig & Chauffeur',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tripData['vehicleName'] as String,
                        style: context.textTheme.titleSmall,
                      ),
                      Text(
                        _tripData['vehiclePlate'] as String,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Chauffeur: ${_tripData['driverName']}',
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniStat(
                  label: 'Gem. snelheid',
                  value: '${_tripData['averageSpeed']} km/u',
                ),
                _MiniStat(
                  label: 'Max. snelheid',
                  value: '${_tripData['maxSpeed']} km/u',
                ),
                _MiniStat(
                  label: 'Brandstof',
                  value: '${_tripData['fuelUsed']} L',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stemming',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _MoodIndicator(
                    label: 'Start',
                    mood: _tripData['startMood'] as String,
                    color: AppColors.moodPositive,
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.grey),
                Expanded(
                  child: _MoodIndicator(
                    label: 'Eind',
                    mood: _tripData['endMood'] as String,
                    color: AppColors.moodNeutral,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentsSection(BuildContext context) {
    final incidentCount = _tripData['incidents'] as int;

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Incidenten',
                  style: context.textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: incidentCount == 0
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                    borderRadius: AppSpacing.borderRadiusFull,
                  ),
                  child: Text(
                    incidentCount == 0 ? 'Geen incidenten' : '$incidentCount incident(en)',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: incidentCount == 0 ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            if (incidentCount == 0) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Deze rit is zonder incidenten verlopen',
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Exporteren als PDF'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Export trip
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning_amber),
              title: const Text('Incident melden'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.reportIncident);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(
                'Verwijderen',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Delete trip confirmation
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  final String location;
  final String time;
  final String km;

  const _RoutePoint({
    required this.location,
    required this.time,
    required this.km,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: context.textTheme.titleSmall,
            ),
            Text(
              time,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
        Text(
          km,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
      ],
    );
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
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.titleSmall,
        ),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

class _MoodIndicator extends StatelessWidget {
  final String label;
  final String mood;
  final Color color;

  const _MoodIndicator({
    required this.label,
    required this.mood,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: AppSpacing.borderRadiusFull,
          ),
          child: Text(
            mood,
            style: context.textTheme.labelMedium?.copyWith(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
