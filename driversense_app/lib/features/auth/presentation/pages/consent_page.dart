import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:driversense_app/shared/widgets/buttons/primary_button.dart';
import 'package:driversense_app/shared/widgets/buttons/secondary_button.dart';

/// Consent page for GDPR compliance
class ConsentPage extends StatefulWidget {
  const ConsentPage({super.key});

  @override
  State<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _acceptedGps = false;

  static const String _consentVersion = '1.0.0';

  bool get _canProceed => _acceptedTerms && _acceptedPrivacy && _acceptedGps;

  void _onAccept() {
    if (_canProceed) {
      context.read<AuthBloc>().add(
        const AuthConsentAccepted(version: _consentVersion),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status,
      listener: (context, state) {
        if (state.isAuthenticated) {
          context.go(Routes.home);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),

                // Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      size: 48,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Title
                Text(
                  'Privacy & Voorwaarden',
                  style: context.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.sm),

                // Description
                Text(
                  'Voordat je kunt beginnen, vragen we je toestemming voor het volgende:',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Consent checkboxes
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _ConsentTile(
                          title: 'Algemene voorwaarden',
                          description: 'Ik ga akkoord met de algemene voorwaarden van DriverSense.',
                          isChecked: _acceptedTerms,
                          onChanged: (value) {
                            setState(() => _acceptedTerms = value ?? false);
                          },
                          onReadMore: () => _showTermsDialog(context),
                        ),
                        const Divider(),
                        _ConsentTile(
                          title: 'Privacyverklaring',
                          description: 'Ik ga akkoord met de verwerking van mijn persoonsgegevens zoals beschreven in de privacyverklaring.',
                          isChecked: _acceptedPrivacy,
                          onChanged: (value) {
                            setState(() => _acceptedPrivacy = value ?? false);
                          },
                          onReadMore: () => _showPrivacyDialog(context),
                        ),
                        const Divider(),
                        _ConsentTile(
                          title: 'GPS-tracking',
                          description: 'Ik geef toestemming voor het vastleggen van mijn locatie tijdens het rijden voor veiligheidsdoeleinden.',
                          isChecked: _acceptedGps,
                          onChanged: (value) {
                            setState(() => _acceptedGps = value ?? false);
                          },
                          onReadMore: () => _showGpsDialog(context),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Buttons
                PrimaryButton(
                  onPressed: _canProceed ? _onAccept : null,
                  text: 'Akkoord en doorgaan',
                ),

                const SizedBox(height: AppSpacing.sm),

                SecondaryButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                  },
                  text: 'Niet akkoord',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Algemene voorwaarden'),
        content: const SingleChildScrollView(
          child: Text(
            'Hier komen de algemene voorwaarden van DriverSense...\n\n'
            'Door gebruik te maken van de DriverSense app ga je akkoord met deze voorwaarden.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sluiten'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacyverklaring'),
        content: const SingleChildScrollView(
          child: Text(
            'DriverSense hecht waarde aan je privacy.\n\n'
            'Wij verzamelen de volgende gegevens:\n'
            '• Persoonlijke gegevens (naam, email)\n'
            '• Locatiegegevens tijdens het rijden\n'
            '• Check-in en check-out informatie\n'
            '• Incidentmeldingen\n\n'
            'Deze gegevens worden gebruikt om je veiligheid te verbeteren en worden niet gedeeld met derden zonder je toestemming.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sluiten'),
          ),
        ],
      ),
    );
  }

  void _showGpsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('GPS-tracking'),
        content: const SingleChildScrollView(
          child: Text(
            'DriverSense registreert je locatie tijdens actieve ritten.\n\n'
            'Dit wordt gebruikt voor:\n'
            '• Routeregistratie\n'
            '• Veiligheidsmonitoring\n'
            '• Incidentlocalisatie\n\n'
            'Je kunt privézones instellen waar geen locatie wordt opgeslagen, zoals je thuisadres.\n\n'
            'GPS-tracking is alleen actief tijdens een rit en wordt automatisch gestopt wanneer je uitcheckt.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sluiten'),
          ),
        ],
      ),
    );
  }
}

/// Widget for consent checkbox tile
class _ConsentTile extends StatelessWidget {
  final String title;
  final String description;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onReadMore;

  const _ConsentTile({
    required this.title,
    required this.description,
    required this.isChecked,
    required this.onChanged,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
                TextButton(
                  onPressed: onReadMore,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Meer lezen'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
