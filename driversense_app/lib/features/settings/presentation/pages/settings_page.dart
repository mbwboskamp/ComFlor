import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/features/auth/presentation/bloc/auth_bloc.dart';

/// Settings page with menu options
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile section
                _buildProfileSection(context, authState),

                const SizedBox(height: AppSpacing.md),

                // App settings
                _SettingsSection(
                  title: 'App instellingen',
                  children: [
                    _SettingsTile(
                      icon: Icons.language,
                      title: 'Taal',
                      subtitle: _getLanguageName(authState.locale.languageCode),
                      onTap: () => context.push(Routes.language),
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Meldingen',
                      subtitle: 'Push- en in-app meldingen',
                      onTap: () => context.push(Routes.notifications),
                    ),
                    _SettingsTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Thema',
                      subtitle: 'Systeem',
                      onTap: () => _showThemeDialog(context),
                    ),
                  ],
                ),

                // Privacy & Security
                _SettingsSection(
                  title: 'Privacy & Beveiliging',
                  children: [
                    _SettingsTile(
                      icon: Icons.location_off_outlined,
                      title: 'Privacyzones',
                      subtitle: 'Beheer gebieden waar tracking gepauzeerd wordt',
                      onTap: () => context.push(Routes.privacyZones),
                    ),
                    _SettingsTile(
                      icon: Icons.fingerprint,
                      title: 'Biometrische beveiliging',
                      subtitle: 'Inloggen met Face ID of vingerafdruk',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // TODO: Toggle biometric
                        },
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Wachtwoord wijzigen',
                      onTap: () {
                        // TODO: Change password flow
                      },
                    ),
                  ],
                ),

                // Data & Storage
                _SettingsSection(
                  title: 'Data & Opslag',
                  children: [
                    _SettingsTile(
                      icon: Icons.cloud_sync_outlined,
                      title: 'Offline data synchroniseren',
                      subtitle: 'Laatst gesynchroniseerd: vandaag 10:30',
                      onTap: () {
                        // TODO: Force sync
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.storage_outlined,
                      title: 'Lokale opslag wissen',
                      subtitle: 'Cache en tijdelijke bestanden',
                      onTap: () => _showClearCacheDialog(context),
                    ),
                  ],
                ),

                // Support
                _SettingsSection(
                  title: 'Ondersteuning',
                  children: [
                    _SettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & FAQ',
                      onTap: () {
                        // TODO: Open help
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.bug_report_outlined,
                      title: 'Probleem melden',
                      onTap: () {
                        // TODO: Report issue
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: 'Over DriverSense',
                      subtitle: 'Versie 1.0.0',
                      onTap: () => _showAboutDialog(context),
                    ),
                  ],
                ),

                // Logout
                Padding(
                  padding: AppSpacing.screenPadding,
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout, color: AppColors.error),
                      label: Text(
                        context.l10n.logout,
                        style: const TextStyle(color: AppColors.error),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AuthState authState) {
    return Card(
      margin: AppSpacing.screenPadding,
      child: InkWell(
        onTap: () {
          // TODO: Open profile edit
        },
        borderRadius: AppSpacing.borderRadiusMd,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: context.colorScheme.primaryContainer,
                child: Text(
                  authState.user.firstName.isNotEmpty
                      ? authState.user.firstName.substring(0, 1).toUpperCase()
                      : 'U',
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${authState.user.firstName} ${authState.user.lastName}',
                      style: context.textTheme.titleMedium,
                    ),
                    Text(
                      authState.user.email,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                    if (authState.user.companyName.isNotEmpty)
                      Text(
                        authState.user.companyName,
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

  String _getLanguageName(String code) {
    return switch (code) {
      'nl' => 'Nederlands',
      'en' => 'English',
      'de' => 'Deutsch',
      'fr' => 'Francais',
      _ => code,
    };
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Systeem'),
              value: 'system',
              groupValue: 'system',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile(
              title: const Text('Licht'),
              value: 'light',
              groupValue: 'system',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile(
              title: const Text('Donker'),
              value: 'dark',
              groupValue: 'system',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cache wissen'),
        content: const Text(
          'Dit verwijdert tijdelijke bestanden en cache data. Je accountgegevens blijven bewaard.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.showSuccessSnackBar('Cache gewist');
            },
            child: const Text('Wissen'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'DriverSense',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.drive_eta,
        size: 48,
        color: AppColors.primary,
      ),
      children: [
        const Text(
          'DriverSense is een app voor professionele chauffeurs om hun ritten te registreren, welzijn te monitoren en veilig te rijden.',
        ),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await context.showConfirmDialog(
      title: context.l10n.logout,
      message: 'Weet je zeker dat je wilt uitloggen?',
      confirmText: context.l10n.logout,
      cancelText: context.l10n.cancel,
      isDangerous: true,
    );

    if (confirmed && context.mounted) {
      context.read<AuthBloc>().add(AuthLogoutRequested());
    }
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}
