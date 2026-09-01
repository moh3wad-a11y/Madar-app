import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../doctors/presentation/providers/doctor_providers.dart';
import '../../data/models/service_model.dart';
import '../providers/service_providers.dart';

class AddEditServiceScreen extends ConsumerStatefulWidget {
  final ServiceModel? existing;

  const AddEditServiceScreen({super.key, this.existing});

  @override
  ConsumerState<AddEditServiceScreen> createState() => _AddEditServiceScreenState();
}

class _AddEditServiceScreenState extends ConsumerState<AddEditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();

  int? _defaultDoctorId;
  bool _isActive = true;
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _nameController.text = existing.name;
      _categoryController.text = existing.category ?? '';
      _priceController.text = existing.price.toStringAsFixed(0);
      _defaultDoctorId = existing.doctorId;
      _isActive = existing.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _submitting = true);
    try {
      final repo = ref.read(serviceRepositoryProvider);
      final price = double.tryParse(_priceController.text.trim()) ?? 0;

      if (_isEditing) {
        await repo.update(
          widget.existing!.copyWith(
            name: _nameController.text.trim(),
            category: _categoryController.text.trim(),
            price: price,
            doctorId: _defaultDoctorId,
            clearDoctor: _defaultDoctorId == null,
            isActive: _isActive,
          ),
          userId: userId,
        );
      } else {
        await repo.create(
          ServiceModel(
            name: _nameController.text.trim(),
            category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
            price: price,
            doctorId: _defaultDoctorId,
            isActive: _isActive,
            createdAt: DateTime.now(),
          ),
          userId: userId,
        );
      }

      ref.invalidate(allServicesProvider);
      ref.invalidate(activeServicesProvider);

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
    final doctorsAsync = ref.watch(activeDoctorsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? l10n.editService : l10n.addService)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.serviceName, prefixIcon: const Icon(Icons.medical_information_outlined)),
              validator: (v) => Validators.required(v, fieldName: l10n.serviceName),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: l10n.categoryOptional, prefixIcon: const Icon(Icons.category_outlined)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: l10n.priceLabel, prefixIcon: const Icon(Icons.payments_outlined)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.nonNegativeAmount(v, fieldName: l10n.priceLabel),
            ),
            const SizedBox(height: 16),
            doctorsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('${l10n.errorGeneric} ($e)'),
              data: (doctors) => DropdownButtonFormField<int?>(
                value: doctors.any((d) => d.id == _defaultDoctorId) ? _defaultDoctorId : null,
                decoration: InputDecoration(
                  labelText: l10n.defaultDoctorOptional,
                  prefixIcon: const Icon(Icons.medical_services_outlined),
                ),
                items: [
                  DropdownMenuItem<int?>(value: null, child: Text(l10n.noDefaultDoctor)),
                  ...doctors.map((d) => DropdownMenuItem<int?>(value: d.id, child: Text(d.name))),
                ],
                onChanged: (value) => setState(() => _defaultDoctorId = value),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.serviceDoctorHelper,
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.active),
              subtitle: Text(l10n.inactiveServicesHidden),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEditing ? l10n.saveChanges : l10n.saveService),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
