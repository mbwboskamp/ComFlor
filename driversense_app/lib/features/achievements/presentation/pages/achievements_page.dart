import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';

/// Achievements page showing badges and accomplishments
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  // Mock achievements data
  List<Map<String, dynamic>> get _achievements => [
    {
      'id': '1',
      'title': 'Veilige Chauffeur',
      'description': '30 dagen zonder incidenten',
      'icon': Icons.shield,
      'color': AppColors.success,
      'isUnlocked': true,
      'unlockedDate': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': '2',
      'title': 'Vroege Vogel',
      'description': '10 ritten voor 7:00 gestart',
      'icon': Icons.wb_sunny,
      'color': AppColors.warning,
      'isUnlocked': true,
      'unlockedDate': DateTime.now().subtract(const Duration(days: 12)),
    },
    {
      'id': '3',
      'title': 'Streak Master',
      'description': '7 dagen achter elkaar gereden',
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
      'isUnlocked': true,
      'unlockedDate': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '4',
      'title': 'Kilometervreter',
      'description': '1000 km gereden',
      'icon': Icons.speed,
      'color': AppColors.primary,
      'isUnlocked': true,
      'unlockedDate': DateTime.now().subtract(const Duration(days: 20)),
    },
    {
      'id': '5',
      'title': 'Check Champion',
      'description': '50 checks voltooid',
      'icon': Icons.checklist,
      'color': AppColors.secondary,
      'isUnlocked': false,
      'progress': 35,
      'total': 50,
    },
    {
      'id': '6',
      'title': 'Feedback Gever',
      'description': '20 stemmingsregistraties',
      'icon': Icons.mood,
      'color': Colors.purple,
      'isUnlocked': false,
      'progress': 15,
      'total': 20,
    },
    {
      'id': '7',
      'title': 'Team Speler',
      'description': '10 berichten gestuurd',
      'icon': Icons.group,
      'color': Colors.teal,
      'isUnlocked': false,
      'progress': 6,
      'total': 10,
    },
    {
      'id': '8',
      'title': 'Perfectionist',
      'description': '100% check score behaald',
      'icon': Icons.star,
      'color': Colors.amber,
      'isUnlocked': false,
      'progress': 0,
      'total': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unlockedAchievements = _achievements.where((a) => a['isUnlocked'] == true).toList();
    final lockedAchievements = _achievements.where((a) => a['isUnlocked'] == false).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.achievements),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            onPressed: () => context.push(Routes.goals),
            tooltip: 'Doelen',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats summary
            _buildStatsSummary(context, unlockedAchievements.length, _achievements.length),

            // Current streak
            _buildStreakCard(context),

            // Unlocked achievements
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text(
                'Behaalde badges (${unlockedAchievements.length})',
                style: context.textTheme.titleMedium,
              ),
            ),
            _buildAchievementsGrid(context, unlockedAchievements),

            // Locked achievements (in progress)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text(
                'In progress (${lockedAchievements.length})',
                style: context.textTheme.titleMedium,
              ),
            ),
            _buildAchievementsGrid(context, lockedAchievements),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSummary(BuildContext context, int unlocked, int total) {
    return Card(
      margin: AppSpacing.screenPadding,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    '$unlocked/$total',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Badges behaald',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 50,
              color: context.colorScheme.outline.withOpacity(0.2),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${((unlocked / total) * 100).round()}%',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    'Voltooiing',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      color: Colors.orange.withOpacity(0.1),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Text(
                '7',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Huidige streak',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    '7 dagen achter elkaar gereden',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsGrid(BuildContext context, List<Map<String, dynamic>> achievements) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.1,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return _AchievementCard(achievement: achievements[index]);
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Map<String, dynamic> achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement['isUnlocked'] as bool;
    final color = achievement['color'] as Color;

    return Card(
      child: InkWell(
        onTap: () => _showAchievementDetail(context),
        borderRadius: AppSpacing.borderRadiusMd,
        child: Padding(
          padding: AppSpacing.cardPaddingCompact,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isUnlocked ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievement['icon'] as IconData,
                  color: isUnlocked ? color : Colors.grey,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                achievement['title'] as String,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isUnlocked ? null : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              if (!isUnlocked && achievement['progress'] != null)
                _buildProgressBar(context, achievement)
              else if (isUnlocked)
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, Map<String, dynamic> achievement) {
    final progress = achievement['progress'] as int;
    final total = achievement['total'] as int;
    final percentage = progress / total;

    return Column(
      children: [
        SizedBox(
          height: 4,
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey.withOpacity(0.2),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$progress/$total',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  void _showAchievementDetail(BuildContext context) {
    final isUnlocked = achievement['isUnlocked'] as bool;
    final color = achievement['color'] as Color;

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
                color: isUnlocked ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement['icon'] as IconData,
                color: isUnlocked ? color : Colors.grey,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              achievement['title'] as String,
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              achievement['description'] as String,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (isUnlocked)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Behaald op ${_formatDate(achievement['unlockedDate'] as DateTime)}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              )
            else ...[
              Text(
                'Voortgang',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(
                value: (achievement['progress'] as int) / (achievement['total'] as int),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${achievement['progress']}/${achievement['total']}',
                style: context.textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}
