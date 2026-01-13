import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/shared/widgets/buttons/primary_button.dart';
import 'package:driversense_app/shared/widgets/buttons/secondary_button.dart';

/// Multi-step end check flow page
/// Flow: KM Input -> Questions -> Mood Selection -> Trip Summary -> Confirmation
class EndCheckPage extends StatefulWidget {
  const EndCheckPage({super.key});

  @override
  State<EndCheckPage> createState() => _EndCheckPageState();
}

class _EndCheckPageState extends State<EndCheckPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Form data
  final _kmController = TextEditingController();
  final Map<String, bool> _questionAnswers = {};
  int? _selectedMood;
  String? _notes;

  // Mock data for current trip
  final Map<String, dynamic> _currentTrip = {
    'vehicleName': 'Vrachtwagen 01',
    'vehiclePlate': 'AB-123-CD',
    'startKm': 125000,
    'startTime': '08:30',
    'duration': '4u 30m',
  };

  // Mock questions for end check
  final List<Map<String, String>> _questions = [
    {'id': 'q1', 'text': 'Zijn er problemen geweest tijdens de rit?'},
    {'id': 'q2', 'text': 'Is er schade aan het voertuig?'},
    {'id': 'q3', 'text': 'Moet er getankt worden?'},
    {'id': 'q4', 'text': 'Zijn er opmerkingen voor de volgende chauffeur?'},
  ];

  // Mood options
  final List<Map<String, dynamic>> _moodOptions = [
    {'value': 1, 'emoji': '😊', 'label': 'Goed'},
    {'value': 2, 'emoji': '😐', 'label': 'Neutraal'},
    {'value': 3, 'emoji': '😔', 'label': 'Vermoeid'},
    {'value': 4, 'emoji': '😰', 'label': 'Gestrest'},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitCheck();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  void _submitCheck() {
    // TODO: Submit end check data to bloc/repository
    context.showSuccessSnackBar(context.l10n.tripEnded);
    context.go(Routes.home);
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _kmController.text.isNotEmpty;
      case 1:
        return _questionAnswers.length == _questions.length;
      case 2:
        return _selectedMood != null;
      case 3:
        return true; // Summary step, always can proceed
      default:
        return false;
    }
  }

  int get _calculatedDistance {
    final endKm = int.tryParse(_kmController.text) ?? 0;
    final startKm = _currentTrip['startKm'] as int;
    return endKm - startKm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.endCheck),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousStep,
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),

          // Step content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildKmInputStep(),
                _buildQuestionsStep(),
                _buildMoodSelectionStep(),
                _buildSummaryStep(),
              ],
            ),
          ),

          // Navigation buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? context.colorScheme.primary
                    : context.colorScheme.surfaceContainerHighest,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildKmInputStep() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current trip info card
          Card(
            color: context.colorScheme.primaryContainer,
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    color: context.colorScheme.primary,
                    size: 40,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentTrip['vehicleName'] as String,
                          style: context.textTheme.titleMedium,
                        ),
                        Text(
                          'Start: ${_currentTrip['startKm']} km om ${_currentTrip['startTime']}',
                          style: context.textTheme.bodySmall,
                        ),
                        Text(
                          'Duur: ${_currentTrip['duration']}',
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Kilometerstand',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Voer de huidige kilometerstand in',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _kmController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Kilometerstand',
              hintText: 'bijv. 125150',
              suffixText: 'km',
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (_kmController.text.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Card(
              child: ListTile(
                leading: const Icon(Icons.straighten),
                title: const Text('Gereden afstand'),
                trailing: Text(
                  '$_calculatedDistance km',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Foto maken van dashboard'),
              subtitle: const Text('Optioneel'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Open camera
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsStep() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Einde rit vragen',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Beantwoord de volgende vragen',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...(_questions.map((question) => _QuestionCard(
                question: question,
                answer: _questionAnswers[question['id']],
                onAnswer: (bool answer) {
                  setState(() {
                    _questionAnswers[question['id']!] = answer;
                  });
                },
              ))),
        ],
      ),
    );
  }

  Widget _buildMoodSelectionStep() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hoe voel je je nu?',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Selecteer je huidige stemming na de rit',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            children: _moodOptions.map((mood) => _MoodCard(
                  mood: mood,
                  isSelected: _selectedMood == mood['value'],
                  onTap: () {
                    setState(() {
                      _selectedMood = mood['value'] as int;
                    });
                  },
                )).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Opmerkingen (optioneel)',
              hintText: 'Voeg eventuele opmerkingen toe...',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              _notes = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep() {
    final startKm = _currentTrip['startKm'] as int;
    final endKm = int.tryParse(_kmController.text) ?? 0;

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Samenvatting',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Controleer de gegevens voordat je bevestigt',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                children: [
                  _SummaryRow(
                    label: 'Voertuig',
                    value: _currentTrip['vehicleName'] as String,
                  ),
                  const Divider(),
                  _SummaryRow(
                    label: 'Start km',
                    value: '$startKm km',
                  ),
                  const Divider(),
                  _SummaryRow(
                    label: 'Eind km',
                    value: '$endKm km',
                  ),
                  const Divider(),
                  _SummaryRow(
                    label: 'Afstand gereden',
                    value: '$_calculatedDistance km',
                    isHighlighted: true,
                  ),
                  const Divider(),
                  _SummaryRow(
                    label: 'Duur',
                    value: _currentTrip['duration'] as String,
                  ),
                  const Divider(),
                  _SummaryRow(
                    label: 'Stemming',
                    value: _moodOptions
                        .firstWhere((m) => m['value'] == _selectedMood)['emoji'] as String,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_notes != null && _notes!.isNotEmpty)
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Opmerkingen',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(_notes!),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: AppSpacing.screenPadding,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: SecondaryButton(
                  onPressed: _previousStep,
                  text: context.l10n.back,
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: _currentStep > 0 ? 2 : 1,
              child: PrimaryButton(
                onPressed: _canProceed ? _nextStep : null,
                text: _currentStep == 3 ? context.l10n.confirm : context.l10n.next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Map<String, String> question;
  final bool? answer;
  final Function(bool) onAnswer;

  const _QuestionCard({
    required this.question,
    required this.answer,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['text']!,
              style: context.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onAnswer(true),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: answer == true
                          ? AppColors.warning.withOpacity(0.1)
                          : null,
                      side: BorderSide(
                        color: answer == true
                            ? AppColors.warning
                            : context.colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      'Ja',
                      style: TextStyle(
                        color: answer == true ? AppColors.warning : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onAnswer(false),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: answer == false
                          ? AppColors.success.withOpacity(0.1)
                          : null,
                      side: BorderSide(
                        color: answer == false
                            ? AppColors.success
                            : context.colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      'Nee',
                      style: TextStyle(
                        color: answer == false ? AppColors.success : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  final Map<String, dynamic> mood;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodCard({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        side: isSelected
            ? BorderSide(color: context.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusMd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mood['emoji'] as String,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              mood['label'] as String,
              style: context.textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          Text(
            value,
            style: isHighlighted
                ? context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  )
                : context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
