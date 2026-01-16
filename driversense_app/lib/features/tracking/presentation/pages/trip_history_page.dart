import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';

/// Trip history page showing list of past trips
class TripHistoryPage extends StatefulWidget {
  const TripHistoryPage({super.key});

  @override
  State<TripHistoryPage> createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
  String _selectedFilter = 'all';

  // Mock trip data
  final List<Map<String, dynamic>> _trips = [
    {
      'id': '1',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'vehicleName': 'Vrachtwagen 01',
      'distance': 87.5,
      'duration': '2u 30m',
      'startLocation': 'Amsterdam',
      'endLocation': 'Rotterdam',
      'status': 'completed',
    },
    {
      'id': '2',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'vehicleName': 'Vrachtwagen 01',
      'distance': 145.2,
      'duration': '3u 45m',
      'startLocation': 'Rotterdam',
      'endLocation': 'Utrecht',
      'status': 'completed',
    },
    {
      'id': '3',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'vehicleName': 'Bestelbus 01',
      'distance': 52.8,
      'duration': '1u 15m',
      'startLocation': 'Utrecht',
      'endLocation': 'Den Haag',
      'status': 'completed',
    },
    {
      'id': '4',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'vehicleName': 'Vrachtwagen 02',
      'distance': 198.0,
      'duration': '4u 20m',
      'startLocation': 'Den Haag',
      'endLocation': 'Eindhoven',
      'status': 'completed',
    },
    {
      'id': '5',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'vehicleName': 'Vrachtwagen 01',
      'distance': 112.3,
      'duration': '2u 50m',
      'startLocation': 'Eindhoven',
      'endLocation': 'Amsterdam',
      'status': 'completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.trips),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary card
          _buildSummaryCard(),

          // Filter chips
          _buildFilterChips(),

          // Trip list
          Expanded(
            child: _trips.isEmpty
                ? _buildEmptyState()
                : _buildTripList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalDistance = _trips.fold<double>(
      0,
      (sum, trip) => sum + (trip['distance'] as double),
    );

    return Card(
      margin: AppSpacing.screenPadding,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            Expanded(
              child: _SummaryItem(
                icon: Icons.route,
                label: 'Totale afstand',
                value: '${totalDistance.toStringAsFixed(1)} km',
                color: AppColors.primary,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: context.colorScheme.outline.withOpacity(0.2),
            ),
            Expanded(
              child: _SummaryItem(
                icon: Icons.local_shipping,
                label: 'Totaal ritten',
                value: '${_trips.length}',
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _FilterChip(
            label: 'Alle',
            isSelected: _selectedFilter == 'all',
            onTap: () => setState(() => _selectedFilter = 'all'),
          ),
          _FilterChip(
            label: 'Deze week',
            isSelected: _selectedFilter == 'week',
            onTap: () => setState(() => _selectedFilter = 'week'),
          ),
          _FilterChip(
            label: 'Deze maand',
            isSelected: _selectedFilter == 'month',
            onTap: () => setState(() => _selectedFilter = 'month'),
          ),
          _FilterChip(
            label: 'Vrachtwagen',
            isSelected: _selectedFilter == 'truck',
            onTap: () => setState(() => _selectedFilter = 'truck'),
          ),
        ],
      ),
    );
  }

  Widget _buildTripList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: _trips.length,
      itemBuilder: (context, index) {
        final trip = _trips[index];
        return _TripCard(
          trip: trip,
          onTap: () => context.push(Routes.tripDetailPath(trip['id'] as String)),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.route_outlined,
            size: 80,
            color: context.colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Geen ritten gevonden',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Je ritten worden hier getoond',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter ritten',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Datum bereik'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Show date range picker
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Voertuig'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Show vehicle picker
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort),
              title: const Text('Sorteren'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Show sort options
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: AppSpacing.xs),
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
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Map<String, dynamic> trip;
  final VoidCallback onTap;

  const _TripCard({
    required this.trip,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tripDate = DateTime(date.year, date.month, date.day);

    if (tripDate == today) {
      return 'Vandaag, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (tripDate == today.subtract(const Duration(days: 1))) {
      return 'Gisteren, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}-${date.month}-${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = trip['date'] as DateTime;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusMd,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: const Icon(
                      Icons.local_shipping,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip['vehicleName'] as String,
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          _formatDate(date),
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
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: context.colorScheme.outline,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${trip['startLocation']} - ${trip['endLocation']}',
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _TripStat(
                    icon: Icons.straighten,
                    value: '${trip['distance']} km',
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _TripStat(
                    icon: Icons.timer_outlined,
                    value: trip['duration'] as String,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripStat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _TripStat({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: context.colorScheme.outline,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
