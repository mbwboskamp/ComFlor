import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/shared/widgets/buttons/primary_button.dart';
import 'package:driversense_app/shared/widgets/buttons/secondary_button.dart';

/// Multi-step start check flow page
/// Flow: Vehicle Selection -> KM Input -> Questions -> Mood Selection -> Confirmation
class StartCheckPage extends StatefulWidget {
  const StartCheckPage({super.key});

  @override
  State<StartCheckPage> createState() => _StartCheckPageState();
}

class _StartCheckPageState extends State<StartCheckPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Form data
  String? _selectedVehicleId;
  final _kmController = TextEditingController();
  final Map<String, bool> _questionAnswers = {};
  int? _selectedMood;

  // Mock data for vehicles
  final List<Map<String, String>> _vehicles = [
    {'id': '1', 'name': 'Vrachtwagen 01', 'plate': 'AB-123-CD'},
    {'id': '2', 'name': 'Vrachtwagen 02', 'plate': 'EF-456-GH'},
    {'id': '3', 'name': 'Bestelbus 01', 'plate': 'IJ-789-KL'},
  ];

  // Mock questions
  final List<Map<String, String>> _questions = [
    {'id': 'q1', 'text': 'Heb je voldoende geslapen? (minimaal 7 uur)'},
    {'id': 'q2', 'text': 'Voel je je fit genoeg om te rijden?'},
    {'id': 'q3', 'text': 'Heb je alcohol of drugs gebruikt in de afgelopen 24 uur?'},
    {'id': 'q4', 'text': 'Gebruik je medicijnen die je rijvaardigheid kunnen beinvloeden?'},
  ];

  // Mood options
  final List<Map<String, dynamic>> _moodOptions = [
    {'value': 1, 'emoji': '😊', 'label': 'Goed'},
    {'value': 2, 'emoji': '😐', 'label': 'Neutraal'},
    {'value': 3, 'emoji': '😔', 'label': 'Niet zo goed'},
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
    // TODO: Submit check data to bloc/repository
    context.showSuccessSnackBar(context.l10n.checkCompleted);
    context.go(Routes.activeTrip);
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _selectedVehicleId != null;
      case 1:
        return _kmController.text.isNotEmpty;
      case 2:
        return _questionAnswers.length == _questions.length;
      case 3:
        return _selectedMood != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.startCheck),
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
                _buildVehicleSelectionStep(),
                _buildKmInputStep(),
                _buildQuestionsStep(),
                _buildMoodSelectionStep(),
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

  Widget _buildVehicleSelectionStep() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecteer voertuig',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Kies het voertuig waarmee je gaat rijden',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...(_vehicles.map((vehicle) => _VehicleCard(
                vehicle: vehicle,
                isSelected: _selectedVehicleId == vehicle['id'],
                onTap: () {
                  setState(() {
                    _selectedVehicleId = vehicle['id'];
                  });
                },
              ))),
        ],
      ),
    );
  }

  Widget _buildKmInputStep() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              hintText: 'bijv. 125000',
              suffixText: 'km',
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
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
            'Rijvaardigheid check',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Beantwoord de volgende vragen eerlijk',
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
            'Hoe voel je je?',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Selecteer je huidige stemming',
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

class _VehicleCard extends StatelessWidget {
  final Map<String, String> vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.vehicle,
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
                  color: context.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_shipping,
                  color: context.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle['name']!,
                      style: context.textTheme.titleMedium,
                    ),
                    Text(
                      vehicle['plate']!,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: context.colorScheme.primary,
                ),
            ],
          ),
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
                          ? AppColors.success.withOpacity(0.1)
                          : null,
                      side: BorderSide(
                        color: answer == true
                            ? AppColors.success
                            : context.colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      'Ja',
                      style: TextStyle(
                        color: answer == true ? AppColors.success : null,
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
                          ? AppColors.error.withOpacity(0.1)
                          : null,
                      side: BorderSide(
                        color: answer == false
                            ? AppColors.error
                            : context.colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      'Nee',
                      style: TextStyle(
                        color: answer == false ? AppColors.error : null,
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
