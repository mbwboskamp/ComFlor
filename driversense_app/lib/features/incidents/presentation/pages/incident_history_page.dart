import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';

/// Incident history page showing list of past incidents
class IncidentHistoryPage extends StatelessWidget {
  const IncidentHistoryPage({super.key});

  // Mock incident data
  List<Map<String, dynamic>> get _incidents => [
    {
      'id': '1',
      'type': 'breakdown',
      'typeLabel': 'Pech',
      'severity': 'medium',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'location': 'A15, km 45',
      'description': 'Lekke band rechtsachter',
      'status': 'resolved',
    },
    {
      'id': '2',
      'type': 'traffic',
      'typeLabel': 'Verkeersincident',
      'severity': 'low',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'location': 'Rotterdam centrum',
      'description': 'Bijna-aanrijding met fietser',
      'status': 'resolved',
    },
    {
      'id': '3',
      'type': 'cargo',
      'typeLabel': 'Lading probleem',
      'severity': 'high',
      'date': DateTime.now().subtract(const Duration(days: 8)),
      'location': 'Distributiecentrum Utrecht',
      'description': 'Beschadigde lading bij levering',
      'status': 'pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidenten'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: _incidents.isEmpty ? _buildEmptyState(context) : _buildIncidentList(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.reportIncident),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.reportIncident),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: AppColors.success.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Geen incidenten',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Je hebt nog geen incidenten gemeld',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentList(BuildContext context) {
    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: _incidents.length,
      itemBuilder: (context, index) {
        final incident = _incidents[index];
        return _IncidentCard(
          incident: incident,
          onTap: () => _showIncidentDetail(context, incident),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter incidenten',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Datum bereik'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Type'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Ernst'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Status'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showIncidentDetail(BuildContext context, Map<String, dynamic> incident) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: AppSpacing.screenPadding,
          child: ListView(
            controller: scrollController,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: AppSpacing.borderRadiusFull,
                  ),
                ),
              ),

              // Header
              Row(
                children: [
                  _buildSeverityBadge(context, incident['severity'] as String),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incident['typeLabel'] as String,
                          style: context.textTheme.titleLarge,
                        ),
                        Text(
                          _formatDate(incident['date'] as DateTime),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(context, incident['status'] as String),
                ],
              ),

              const Divider(height: AppSpacing.xl),

              // Location
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Locatie'),
                subtitle: Text(incident['location'] as String),
              ),

              // Description
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_outlined),
                title: const Text('Beschrijving'),
                subtitle: Text(incident['description'] as String),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Edit incident
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Bewerken'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Delete incident
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      label: Text(
                        'Verwijderen',
                        style: TextStyle(color: AppColors.error),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(BuildContext context, String severity) {
    final color = switch (severity) {
      'high' => AppColors.urgentHigh,
      'medium' => AppColors.urgentMedium,
      _ => AppColors.urgentLow,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.warning, color: color),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final isResolved = status == 'resolved';
    final color = isResolved ? AppColors.success : AppColors.warning;
    final label = isResolved ? 'Opgelost' : 'In behandeling';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppSpacing.borderRadiusFull,
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final incidentDate = DateTime(date.year, date.month, date.day);

    if (incidentDate == today) {
      return 'Vandaag';
    } else if (incidentDate == today.subtract(const Duration(days: 1))) {
      return 'Gisteren';
    } else {
      return '${date.day}-${date.month}-${date.year}';
    }
  }
}

class _IncidentCard extends StatelessWidget {
  final Map<String, dynamic> incident;
  final VoidCallback onTap;

  const _IncidentCard({
    required this.incident,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final severity = incident['severity'] as String;
    final severityColor = switch (severity) {
      'high' => AppColors.urgentHigh,
      'medium' => AppColors.urgentMedium,
      _ => AppColors.urgentLow,
    };

    final status = incident['status'] as String;
    final isResolved = status == 'resolved';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                  color: severityColor.withOpacity(0.1),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(
                  Icons.warning,
                  color: severityColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          incident['typeLabel'] as String,
                          style: context.textTheme.titleSmall,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isResolved
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.warning.withOpacity(0.1),
                            borderRadius: AppSpacing.borderRadiusFull,
                          ),
                          child: Text(
                            isResolved ? 'Opgelost' : 'Open',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: isResolved ? AppColors.success : AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      incident['description'] as String,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.outline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: context.colorScheme.outline,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          incident['location'] as String,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ],
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
