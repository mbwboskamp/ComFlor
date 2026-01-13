import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/shared/widgets/buttons/primary_button.dart';
import 'package:driversense_app/shared/widgets/buttons/secondary_button.dart';

/// Report incident page with voice recording capability
class ReportIncidentPage extends StatefulWidget {
  final String? tripId;

  const ReportIncidentPage({
    super.key,
    this.tripId,
  });

  @override
  State<ReportIncidentPage> createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends State<ReportIncidentPage> {
  String? _selectedType;
  String? _selectedSeverity;
  final _descriptionController = TextEditingController();
  bool _isRecording = false;
  bool _hasRecording = false;
  Duration _recordingDuration = Duration.zero;
  final List<String> _attachedPhotos = [];

  // Incident types
  final List<Map<String, dynamic>> _incidentTypes = [
    {'id': 'accident', 'label': 'Ongeval', 'icon': Icons.car_crash},
    {'id': 'breakdown', 'label': 'Pech', 'icon': Icons.build},
    {'id': 'traffic', 'label': 'Verkeersincident', 'icon': Icons.traffic},
    {'id': 'cargo', 'label': 'Lading probleem', 'icon': Icons.inventory},
    {'id': 'health', 'label': 'Gezondheid', 'icon': Icons.medical_services},
    {'id': 'other', 'label': 'Overig', 'icon': Icons.more_horiz},
  ];

  // Severity levels
  final List<Map<String, dynamic>> _severityLevels = [
    {'id': 'low', 'label': 'Laag', 'color': AppColors.urgentLow},
    {'id': 'medium', 'label': 'Medium', 'color': AppColors.urgentMedium},
    {'id': 'high', 'label': 'Hoog', 'color': AppColors.urgentHigh},
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _selectedType != null &&
      _selectedSeverity != null &&
      (_descriptionController.text.isNotEmpty || _hasRecording);

  void _toggleRecording() {
    setState(() {
      if (_isRecording) {
        _isRecording = false;
        _hasRecording = true;
      } else {
        _isRecording = true;
        _hasRecording = false;
        _recordingDuration = Duration.zero;
        // TODO: Start actual recording
        _startRecordingTimer();
      }
    });
  }

  void _startRecordingTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_isRecording && mounted) {
        setState(() {
          _recordingDuration += const Duration(seconds: 1);
        });
        return true;
      }
      return false;
    });
  }

  void _submitIncident() {
    // TODO: Submit incident to bloc/repository
    context.showSuccessSnackBar('Incident gemeld');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reportIncident),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Incident type selection
            Text(
              'Type incident',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildIncidentTypeGrid(),

            const SizedBox(height: AppSpacing.lg),

            // Severity selection
            Text(
              'Ernst',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSeveritySelection(),

            const SizedBox(height: AppSpacing.lg),

            // Voice recording
            Text(
              'Spraakbericht (optioneel)',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildVoiceRecordingCard(),

            const SizedBox(height: AppSpacing.lg),

            // Description
            Text(
              'Beschrijving',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Beschrijf het incident...',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Photo attachments
            Text(
              'Foto\'s (optioneel)',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildPhotoSection(),

            const SizedBox(height: AppSpacing.lg),

            // Location info
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: AppColors.info),
                ),
                title: const Text('Locatie wordt automatisch toegevoegd'),
                subtitle: const Text('Op basis van GPS'),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildIncidentTypeGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1,
      children: _incidentTypes.map((type) {
        final isSelected = _selectedType == type['id'];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            side: isSelected
                ? BorderSide(color: context.colorScheme.primary, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: () => setState(() => _selectedType = type['id'] as String),
            borderRadius: AppSpacing.borderRadiusMd,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  type['icon'] as IconData,
                  size: 28,
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.outline,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  type['label'] as String,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isSelected ? context.colorScheme.primary : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeveritySelection() {
    return Row(
      children: _severityLevels.map((severity) {
        final isSelected = _selectedSeverity == severity['id'];
        final color = severity['color'] as Color;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: OutlinedButton(
              onPressed: () => setState(() => _selectedSeverity = severity['id'] as String),
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected ? color.withOpacity(0.1) : null,
                side: BorderSide(
                  color: isSelected ? color : context.colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: Text(
                severity['label'] as String,
                style: TextStyle(
                  color: isSelected ? color : null,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVoiceRecordingCard() {
    return Card(
      color: _isRecording ? AppColors.error.withOpacity(0.1) : null,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            if (_hasRecording && !_isRecording) ...[
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: AppColors.success),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Opname klaar'),
                        Text(
                          _formatDuration(_recordingDuration),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      // TODO: Play recording
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: () {
                      setState(() {
                        _hasRecording = false;
                        _recordingDuration = Duration.zero;
                      });
                    },
                  ),
                ],
              ),
            ] else ...[
              GestureDetector(
                onTap: _toggleRecording,
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _isRecording ? AppColors.error : context.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _isRecording
                          ? 'Tap om te stoppen'
                          : 'Tap om op te nemen',
                      style: context.textTheme.bodyMedium,
                    ),
                    if (_isRecording)
                      Text(
                        _formatDuration(_recordingDuration),
                        style: context.textTheme.titleMedium?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Add photo button
          Card(
            child: InkWell(
              onTap: () {
                // TODO: Open camera or gallery
              },
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      color: context.colorScheme.outline,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Toevoegen',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Attached photos placeholder
          ..._attachedPhotos.map((photo) => Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                      child: const Icon(Icons.image),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _attachedPhotos.remove(photo);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
            Expanded(
              child: SecondaryButton(
                onPressed: () => context.pop(),
                text: context.l10n.cancel,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                onPressed: _canSubmit ? _submitIncident : null,
                text: 'Melden',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
