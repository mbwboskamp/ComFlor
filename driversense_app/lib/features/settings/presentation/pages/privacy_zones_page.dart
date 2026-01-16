import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/shared/widgets/buttons/primary_button.dart';

/// Privacy zones management page
class PrivacyZonesPage extends StatefulWidget {
  const PrivacyZonesPage({super.key});

  @override
  State<PrivacyZonesPage> createState() => _PrivacyZonesPageState();
}

class _PrivacyZonesPageState extends State<PrivacyZonesPage> {
  // Mock privacy zones data
  final List<Map<String, dynamic>> _privacyZones = [
    {
      'id': '1',
      'name': 'Thuis',
      'address': 'Hoofdstraat 123, Amsterdam',
      'radius': 200,
      'isActive': true,
    },
    {
      'id': '2',
      'name': 'Ouders',
      'address': 'Kerkweg 45, Utrecht',
      'radius': 150,
      'isActive': true,
    },
    {
      'id': '3',
      'name': 'Sportschool',
      'address': 'Sportlaan 10, Amsterdam',
      'radius': 100,
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacyzones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info banner
          _buildInfoBanner(),

          // Zones list
          Expanded(
            child: _privacyZones.isEmpty
                ? _buildEmptyState()
                : _buildZonesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddZoneDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Zone toevoegen'),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: AppSpacing.screenPadding,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'In privacyzones wordt GPS-tracking automatisch gepauzeerd om je privacy te beschermen.',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 80,
            color: context.colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Geen privacyzones',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Voeg zones toe waar tracking moet worden gepauzeerd',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildZonesList() {
    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: _privacyZones.length,
      itemBuilder: (context, index) {
        final zone = _privacyZones[index];
        return _PrivacyZoneCard(
          zone: zone,
          onToggle: (value) {
            setState(() {
              _privacyZones[index]['isActive'] = value;
            });
          },
          onEdit: () => _showEditZoneDialog(zone),
          onDelete: () => _showDeleteConfirmation(zone),
        );
      },
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Over privacyzones'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacyzones zijn gebieden waar je locatiegegevens niet worden geregistreerd.',
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Wanneer je een privacyzone binnenkomt:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSpacing.sm),
            Text('- GPS-tracking wordt gepauzeerd'),
            Text('- Locatie wordt niet opgeslagen'),
            Text('- Alleen de tijd wordt bijgehouden'),
            SizedBox(height: AppSpacing.md),
            Text(
              'Je kunt maximaal 10 privacyzones instellen.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Begrepen'),
          ),
        ],
      ),
    );
  }

  void _showAddZoneDialog() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    int radius = 200;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nieuwe privacyzone',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Naam',
                  hintText: 'bijv. Thuis',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Adres',
                  hintText: 'Zoek of kies op kaart',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      // TODO: Open map picker
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Radius: $radius meter',
                style: context.textTheme.titleSmall,
              ),
              Slider(
                value: radius.toDouble(),
                min: 50,
                max: 500,
                divisions: 9,
                label: '$radius m',
                onChanged: (value) {
                  setModalState(() => radius = value.round());
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        addressController.text.isNotEmpty) {
                      setState(() {
                        _privacyZones.add({
                          'id': DateTime.now().millisecondsSinceEpoch.toString(),
                          'name': nameController.text,
                          'address': addressController.text,
                          'radius': radius,
                          'isActive': true,
                        });
                      });
                      Navigator.pop(context);
                      context.showSuccessSnackBar('Privacyzone toegevoegd');
                    }
                  },
                  text: 'Toevoegen',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditZoneDialog(Map<String, dynamic> zone) {
    final nameController = TextEditingController(text: zone['name'] as String);
    final addressController = TextEditingController(text: zone['address'] as String);
    int radius = zone['radius'] as int;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacyzone bewerken',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Naam',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Adres',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      // TODO: Open map picker
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Radius: $radius meter',
                style: context.textTheme.titleSmall,
              ),
              Slider(
                value: radius.toDouble(),
                min: 50,
                max: 500,
                divisions: 9,
                label: '$radius m',
                onChanged: (value) {
                  setModalState(() => radius = value.round());
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {
                    final index = _privacyZones.indexWhere((z) => z['id'] == zone['id']);
                    if (index != -1) {
                      setState(() {
                        _privacyZones[index] = {
                          ...zone,
                          'name': nameController.text,
                          'address': addressController.text,
                          'radius': radius,
                        };
                      });
                    }
                    Navigator.pop(context);
                    context.showSuccessSnackBar('Privacyzone bijgewerkt');
                  },
                  text: 'Opslaan',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Map<String, dynamic> zone) async {
    final confirmed = await context.showConfirmDialog(
      title: 'Zone verwijderen',
      message: 'Weet je zeker dat je "${zone['name']}" wilt verwijderen?',
      confirmText: 'Verwijderen',
      cancelText: context.l10n.cancel,
      isDangerous: true,
    );

    if (confirmed) {
      setState(() {
        _privacyZones.removeWhere((z) => z['id'] == zone['id']);
      });
      if (mounted) {
        context.showSuccessSnackBar('Privacyzone verwijderd');
      }
    }
  }
}

class _PrivacyZoneCard extends StatelessWidget {
  final Map<String, dynamic> zone;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PrivacyZoneCard({
    required this.zone,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = zone['isActive'] as bool;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.success.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off,
                color: isActive ? AppColors.success : Colors.grey,
              ),
            ),
            title: Text(zone['name'] as String),
            subtitle: Text(zone['address'] as String),
            trailing: Switch(
              value: isActive,
              onChanged: onToggle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.radio_button_checked,
                  size: 16,
                  color: context.colorScheme.outline,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Radius: ${zone['radius']} m',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Bewerken'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  ),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 16, color: AppColors.error),
                  label: const Text(
                    'Verwijderen',
                    style: TextStyle(color: AppColors.error),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
