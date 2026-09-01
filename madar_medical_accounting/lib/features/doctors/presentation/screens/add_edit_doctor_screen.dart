import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/doctor_model.dart';
import '../providers/doctor_providers.dart';

class AddEditDoctorScreen extends ConsumerStatefulWidget {
  final DoctorModel? existing;

  const AddEditDoctorScreen({super.key, this.existing});

  @override
  ConsumerState<AddEditDoctorScreen> createState() => _AddEditDoctorScreenState();
}

class _AddEditDoctorScreenState extends ConsumerState<AddEditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _commissionValueController = TextEditingController(text: '0');

  String _commissionType = 'none';
  bool _isActive = true;
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _nameController.text = existing.name;
      _specialtyController.text = existing.specialty ?? '';
      _phoneController.text = existing.phone ?? '';
      _commissionType = existing.commissionType;
      _commissionValueController.text = existing.commissionValue.toStringAsFixed(0);
      _isActive = existing.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _phoneController.dispose();
    _commissionValueController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) return;

    final l10n = AppLocalizations.of(context)!;
    final commissionValue = double.tryParse(_commissionValueController.text.trim()) ?? 0;

    setState(() => _submitting = true);
    try {
      final repo = ref.read(doctorRepositoryProvider);

      if (_isEditing) {
        await repo.update(
          widget.existing!.copyWith(
            name: _nameController.text.trim(),
            specialty: _specialtyController.text.trim(),
            phone: _phoneController.text.trim(),
            commissionType: _commissionType,
            commissionValue: commissionValue,
            isActive: _isActive,
          ),
          userId: userId,
        );
      } else {
        await repo.create(
          DoctorModel(
            name: _nameController.text.trim(),
            specialty: _specialtyController.text.trim().isEmpty ? null : _specialtyController.text.trim(),
            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            commissionType: _commissionType,
            commissionValue: commissionValue,
            isActive: _isActive,
            createdAt: DateTime.now(),
          ),
          userId: userId,
        );
      }

      ref.invalidate(allDoctorsProvider);
      ref.invalidate(activeDoctorsProvider);

      if (mounted) Navigator.of(context).pop(true);
    } on AppException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.errorGeneric} ($e)')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? l10n.editDoctor : l10n.addDoctor)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.doctorName, prefixIcon: const Icon(Icons.badge_outlined)),
              validator: (v) => Validators.required(v, fieldName: l10n.doctorName),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _specialtyController,
              decoration: InputDecoration(labelText: l10n.specialtyOptional, prefixIcon: const Icon(Icons.local_hospital_outlined)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: l10n.phoneOptional, prefixIcon: const Icon(Icons.phone_outlined)),
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            const SizedBox(height: 20),
            Text(l10n.commissionStructure, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'none', label: Text(l10n.commissionNone)),
                ButtonSegment(value: 'percentage', label: Text(l10n.commissionPercentage)),
                ButtonSegment(value: 'fixed', label: Text(l10n.commissionFixed)),
              ],
              selected: {_commissionType},
              onSelectionChanged: (selection) => setState(() => _commissionType = selection.first),
            ),
            if (_commissionType != 'none') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _commissionValueController,
                decoration: InputDecoration(
                  labelText: _commissionType == 'percentage' ? l10n.commissionPercentLabel : l10n.commissionFixedLabel,
                  prefixIcon: Icon(_commissionType == 'percentage' ? Icons.percent : Icons.payments_outlined),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => Validators.nonNegativeAmount(v, fieldName: l10n.commission),
              ),
              if (_commissionType == 'fixed') ...[
                const SizedBox(height: 8),
                Text(
                  l10n.commissionFixedHelper,
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
                ),
              ],
            ],
            const SizedBox(height: 20),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.active),
              subtitle: Text(l10n.inactiveDoctorsHidden),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEditing ? l10n.saveChanges : l10n.saveDoctor),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
