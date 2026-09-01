import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/patient_model.dart';
import '../providers/patient_providers.dart';

class AddEditPatientScreen extends ConsumerStatefulWidget {
  final PatientModel? existing;

  const AddEditPatientScreen({super.key, this.existing});

  @override
  ConsumerState<AddEditPatientScreen> createState() => _AddEditPatientScreenState();
}

class _AddEditPatientScreenState extends ConsumerState<AddEditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  String? _gender;
  DateTime? _dateOfBirth;
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _nameController.text = existing.name;
      _phoneController.text = existing.phone ?? '';
      _notesController.text = existing.notes ?? '';
      _gender = existing.gender;
      _dateOfBirth = existing.dateOfBirth;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _submitting = true);
    try {
      final repo = ref.read(patientRepositoryProvider);

      if (_isEditing) {
        await repo.update(
          widget.existing!.copyWith(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            gender: _gender,
            dateOfBirth: _dateOfBirth,
            clearDateOfBirth: _dateOfBirth == null,
            notes: _notesController.text.trim(),
          ),
          userId: userId,
        );
      } else {
        await repo.create(
          PatientModel(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            gender: _gender,
            dateOfBirth: _dateOfBirth,
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            createdAt: DateTime.now(),
          ),
          userId: userId,
        );
      }

      ref.invalidate(patientSearchProvider);

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
      appBar: AppBar(title: Text(_isEditing ? l10n.editPatient : l10n.addPatient)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.fullName, prefixIcon: const Icon(Icons.person_outline)),
              validator: (v) => Validators.required(v, fieldName: l10n.fullName),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: l10n.phoneOptional, prefixIcon: const Icon(Icons.phone_outlined)),
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: InputDecoration(labelText: l10n.genderOptional, prefixIcon: const Icon(Icons.wc_outlined)),
              items: [
                DropdownMenuItem(value: 'male', child: Text(l10n.genderMale)),
                DropdownMenuItem(value: 'female', child: Text(l10n.genderFemale)),
              ],
              onChanged: (value) => setState(() => _gender = value),
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickDateOfBirth,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.dateOfBirthOptional,
                  prefixIcon: const Icon(Icons.cake_outlined),
                  suffixIcon: _dateOfBirth != null
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => setState(() => _dateOfBirth = null),
                        )
                      : const Icon(Icons.chevron_right),
                ),
                child: Text(_dateOfBirth != null ? DateFormatter.toDisplay(_dateOfBirth!) : l10n.notSet),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: l10n.notesOptional, prefixIcon: const Icon(Icons.notes_outlined)),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEditing ? l10n.saveChanges : l10n.savePatient),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
