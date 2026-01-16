import 'package:flutter/material.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';

/// Notification settings page
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Notification settings state
  bool _pushEnabled = true;
  bool _tripReminders = true;
  bool _checkReminders = true;
  bool _achievementAlerts = true;
  bool _chatMessages = true;
  bool _incidentUpdates = true;
  bool _systemUpdates = false;
  bool _marketingMessages = false;

  // Quiet hours
  bool _quietHoursEnabled = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meldingen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master toggle
            _buildMasterToggle(),

            // Push notification settings
            if (_pushEnabled) ...[
              _NotificationSection(
                title: 'Rit meldingen',
                children: [
                  _NotificationTile(
                    icon: Icons.notifications_active,
                    title: 'Rit herinneringen',
                    subtitle: 'Herinnering om je rit te starten',
                    value: _tripReminders,
                    onChanged: (value) => setState(() => _tripReminders = value),
                  ),
                  _NotificationTile(
                    icon: Icons.checklist,
                    title: 'Check herinneringen',
                    subtitle: 'Herinnering voor start- en eindcheck',
                    value: _checkReminders,
                    onChanged: (value) => setState(() => _checkReminders = value),
                  ),
                ],
              ),

              _NotificationSection(
                title: 'Communicatie',
                children: [
                  _NotificationTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'Chatberichten',
                    subtitle: 'Nieuwe berichten van planner',
                    value: _chatMessages,
                    onChanged: (value) => setState(() => _chatMessages = value),
                  ),
                  _NotificationTile(
                    icon: Icons.warning_amber,
                    title: 'Incident updates',
                    subtitle: 'Updates over gemelde incidenten',
                    value: _incidentUpdates,
                    onChanged: (value) => setState(() => _incidentUpdates = value),
                  ),
                ],
              ),

              _NotificationSection(
                title: 'Overig',
                children: [
                  _NotificationTile(
                    icon: Icons.emoji_events,
                    title: 'Prestaties',
                    subtitle: 'Nieuwe badges en doelen behaald',
                    value: _achievementAlerts,
                    onChanged: (value) => setState(() => _achievementAlerts = value),
                  ),
                  _NotificationTile(
                    icon: Icons.system_update,
                    title: 'Systeem updates',
                    subtitle: 'App updates en onderhoud',
                    value: _systemUpdates,
                    onChanged: (value) => setState(() => _systemUpdates = value),
                  ),
                  _NotificationTile(
                    icon: Icons.campaign,
                    title: 'Marketing berichten',
                    subtitle: 'Nieuws en aanbiedingen',
                    value: _marketingMessages,
                    onChanged: (value) => setState(() => _marketingMessages = value),
                  ),
                ],
              ),

              // Quiet hours
              _buildQuietHours(),
            ],

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterToggle() {
    return Card(
      margin: AppSpacing.screenPadding,
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: _pushEnabled
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _pushEnabled ? Icons.notifications_active : Icons.notifications_off,
            color: _pushEnabled ? AppColors.primary : Colors.grey,
          ),
        ),
        title: const Text('Push meldingen'),
        subtitle: Text(
          _pushEnabled ? 'Ingeschakeld' : 'Uitgeschakeld',
        ),
        value: _pushEnabled,
        onChanged: (value) => setState(() => _pushEnabled = value),
      ),
    );
  }

  Widget _buildQuietHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Text(
            'Stille uren',
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            children: [
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: _quietHoursEnabled
                        ? AppColors.secondary.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.do_not_disturb_on,
                    color: _quietHoursEnabled ? AppColors.secondary : Colors.grey,
                  ),
                ),
                title: const Text('Stille uren inschakelen'),
                subtitle: const Text('Geen meldingen tijdens deze periode'),
                value: _quietHoursEnabled,
                onChanged: (value) => setState(() => _quietHoursEnabled = value),
              ),
              if (_quietHoursEnabled) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Starttijd'),
                  trailing: Text(
                    _formatTimeOfDay(_quietStart),
                    style: context.textTheme.titleSmall,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _quietStart,
                    );
                    if (time != null) {
                      setState(() => _quietStart = time);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Eindtijd'),
                  trailing: Text(
                    _formatTimeOfDay(_quietEnd),
                    style: context.textTheme.titleSmall,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _quietEnd,
                    );
                    if (time != null) {
                      setState(() => _quietEnd = time);
                    }
                  },
                ),
              ],
            ],
          ),
        ),
        if (_quietHoursEnabled)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Container(
              padding: AppSpacing.cardPaddingCompact,
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Kritieke meldingen zoals noodgevallen worden nog steeds getoond.',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _NotificationSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _NotificationSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: context.colorScheme.outline),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
