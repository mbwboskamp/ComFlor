import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/features/auth/presentation/bloc/auth_bloc.dart';

/// Language selection page
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  // Supported languages
  List<Map<String, String>> get _languages => [
    {
      'code': 'nl',
      'name': 'Nederlands',
      'nativeName': 'Nederlands',
      'flag': 'NL',
    },
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
      'flag': 'GB',
    },
    {
      'code': 'de',
      'name': 'German',
      'nativeName': 'Deutsch',
      'flag': 'DE',
    },
    {
      'code': 'fr',
      'name': 'French',
      'nativeName': 'Francais',
      'flag': 'FR',
    },
    {
      'code': 'pl',
      'name': 'Polish',
      'nativeName': 'Polski',
      'flag': 'PL',
    },
    {
      'code': 'ro',
      'name': 'Romanian',
      'nativeName': 'Romana',
      'flag': 'RO',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taal'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final currentLanguage = authState.locale.languageCode;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info banner
              Container(
                margin: AppSpacing.screenPadding,
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.translate, color: AppColors.info),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'De app wordt weergegeven in de geselecteerde taal.',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Language list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    final isSelected = language['code'] == currentLanguage;

                    return _LanguageTile(
                      language: language,
                      isSelected: isSelected,
                      onTap: () => _selectLanguage(context, language['code']!),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _selectLanguage(BuildContext context, String languageCode) {
    context.read<AuthBloc>().add(AuthLocaleChanged(Locale(languageCode)));
    context.showSuccessSnackBar('Taal gewijzigd');
    context.pop();
  }
}

class _LanguageTile extends StatelessWidget {
  final Map<String, String> language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        side: isSelected
            ? BorderSide(color: context.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          child: Text(
            _getFlagEmoji(language['flag']!),
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(
          language['nativeName']!,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          language['name']!,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: context.colorScheme.primary,
              )
            : null,
      ),
    );
  }

  String _getFlagEmoji(String countryCode) {
    // Convert country code to flag emoji
    // Each letter is converted to regional indicator symbol
    final flags = {
      'NL': '🇳🇱',
      'GB': '🇬🇧',
      'DE': '🇩🇪',
      'FR': '🇫🇷',
      'PL': '🇵🇱',
      'RO': '🇷🇴',
    };
    return flags[countryCode] ?? countryCode;
  }
}
