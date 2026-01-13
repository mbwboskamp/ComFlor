import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';

/// Goals page for tracking personal and company goals
class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  // Mock goals data
  List<Map<String, dynamic>> get _personalGoals => [
    {
      'id': '1',
      'title': 'Weekelijks 500 km rijden',
      'description': 'Behaal minimaal 500 km per week',
      'current': 320,
      'target': 500,
      'unit': 'km',
      'deadline': 'Deze week',
      'type': 'distance',
    },
    {
      'id': '2',
      'title': 'Geen incidenten deze maand',
      'description': 'Rij een hele maand zonder incidenten',
      'current': 15,
      'target': 30,
      'unit': 'dagen',
      'deadline': 'Deze maand',
      'type': 'safety',
    },
    {
      'id': '3',
      'title': 'Dagelijkse checks voltooien',
      'description': 'Voltooi elke dag je start- en eindcheck',
      'current': 5,
      'target': 7,
      'unit': 'dagen',
      'deadline': 'Deze week',
      'type': 'compliance',
    },
  ];

  List<Map<String, dynamic>> get _companyGoals => [
    {
      'id': '4',
      'title': 'Team veiligheidscore 95%',
      'description': 'Behaal als team een veiligheidscore van 95%',
      'current': 92,
      'target': 95,
      'unit': '%',
      'deadline': 'Dit kwartaal',
      'type': 'team',
    },
    {
      'id': '5',
      'title': 'Brandstofreductie 10%',
      'description': 'Verminder brandstofverbruik met 10%',
      'current': 7,
      'target': 10,
      'unit': '%',
      'deadline': 'Dit jaar',
      'type': 'efficiency',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doelen'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall progress
            _buildOverallProgress(context),

            const SizedBox(height: AppSpacing.lg),

            // Personal goals
            Text(
              'Persoonlijke doelen',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            ..._personalGoals.map((goal) => _GoalCard(goal: goal)),

            const SizedBox(height: AppSpacing.lg),

            // Company goals
            Text(
              'Bedrijfsdoelen',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            ..._companyGoals.map((goal) => _GoalCard(goal: goal)),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgress(BuildContext context) {
    final allGoals = [..._personalGoals, ..._companyGoals];
    final completedCount = allGoals.where((g) {
      final current = g['current'] as int;
      final target = g['target'] as int;
      return current >= target;
    }).length;

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voortgang doelen',
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$completedCount van ${allGoals.length} doelen behaald',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: completedCount / allGoals.length,
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                      ),
                      Text(
                        '${((completedCount / allGoals.length) * 100).round()}%',
                        style: context.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _MiniProgressIndicator(
                  label: 'Afstand',
                  progress: 0.64,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                _MiniProgressIndicator(
                  label: 'Veiligheid',
                  progress: 0.50,
                  color: AppColors.success,
                ),
                const SizedBox(width: AppSpacing.md),
                _MiniProgressIndicator(
                  label: 'Compliance',
                  progress: 0.71,
                  color: AppColors.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniProgressIndicator extends StatelessWidget {
  final String label;
  final double progress;
  final Color color;

  const _MiniProgressIndicator({
    required this.label,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            height: 4,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Map<String, dynamic> goal;

  const _GoalCard({required this.goal});

  Color get _typeColor {
    final type = goal['type'] as String;
    return switch (type) {
      'distance' => AppColors.primary,
      'safety' => AppColors.success,
      'compliance' => AppColors.secondary,
      'team' => Colors.purple,
      'efficiency' => Colors.teal,
      _ => AppColors.info,
    };
  }

  IconData get _typeIcon {
    final type = goal['type'] as String;
    return switch (type) {
      'distance' => Icons.straighten,
      'safety' => Icons.shield,
      'compliance' => Icons.checklist,
      'team' => Icons.group,
      'efficiency' => Icons.eco,
      _ => Icons.flag,
    };
  }

  @override
  Widget build(BuildContext context) {
    final current = goal['current'] as int;
    final target = goal['target'] as int;
    final progress = current / target;
    final isCompleted = current >= target;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: () => _showGoalDetail(context),
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
                      color: _typeColor.withOpacity(0.1),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: Icon(
                      _typeIcon,
                      color: _typeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal['title'] as String,
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          goal['deadline'] as String,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    const Icon(Icons.check_circle, color: AppColors.success)
                  else
                    Text(
                      '${(progress * 100).round()}%',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: _typeColor,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: AppSpacing.borderRadiusFull,
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation(
                          isCompleted ? AppColors.success : _typeColor,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    '$current/${target} ${goal['unit']}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.outline,
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

  void _showGoalDetail(BuildContext context) {
    final current = goal['current'] as int;
    final target = goal['target'] as int;
    final progress = current / target;
    final isCompleted = current >= target;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: _typeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _typeIcon,
                color: _typeColor,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              goal['title'] as String,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              goal['description'] as String,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatItem(
                  label: 'Huidig',
                  value: '$current ${goal['unit']}',
                ),
                Container(
                  width: 1,
                  height: 30,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  color: context.colorScheme.outline.withOpacity(0.2),
                ),
                _StatItem(
                  label: 'Doel',
                  value: '$target ${goal['unit']}',
                ),
                Container(
                  width: 1,
                  height: 30,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  color: context.colorScheme.outline.withOpacity(0.2),
                ),
                _StatItem(
                  label: 'Deadline',
                  value: goal['deadline'] as String,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: AppSpacing.borderRadiusFull,
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(
                    isCompleted ? AppColors.success : _typeColor,
                  ),
                  minHeight: 12,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isCompleted
                  ? 'Doel behaald!'
                  : 'Nog ${target - current} ${goal['unit']} te gaan',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isCompleted ? AppColors.success : _typeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
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
