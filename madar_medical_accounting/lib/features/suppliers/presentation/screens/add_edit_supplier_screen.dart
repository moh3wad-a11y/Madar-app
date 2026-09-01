import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/supplier_model.dart';
import '../providers/supplier_providers.dart';

class AddEditSupplierScreen extends ConsumerStatefulWidget {
  final SupplierModel? existing;

  const AddEditSupplierScreen({super.key, this.existing});

  @override
  ConsumerState<AddEditSupplierScreen> createState() => _AddEditSupplierScreenState();
}

class _AddEditSupplierScreenState extends ConsumerState<AddEditSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _notesController = TextEditingController();
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _nameController.text = existing.name;
      _phoneController.text = existing.phone ?? '';
      _addressController.text = existing.address ?? '';
      _taxIdController.text = existing.taxId ?? '';
      _notesController.text = existing.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _taxIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _submitting = true);
    try {
      final repo = ref.read(supplierRepositoryProvider);

      if (_isEditing) {
        await repo.update(
          widget.existing!.copyWith(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            taxId: _taxIdController.text.trim(),
            notes: _notesController.text.trim(),
          ),
          userId: userId,
        );
      } else {
        await repo.create(
          SupplierModel(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
            taxId: _taxIdController.text.trim().isEmpty ? null : _taxIdController.text.trim(),
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            createdAt: DateTime.now(),
          ),
          userId: userId,
        );
      }

      ref.invalidate(supplierSearchProvider);

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
      appBar: AppBar(title: Text(_isEditing ? l10n.editSupplier : l10n.addSupplier)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.supplierName, prefixIcon: const Icon(Icons.business_outlined)),
              validator: (v) => Validators.required(v, fieldName: l10n.supplierName),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: l10n.phoneOptional, prefixIcon: const Icon(Icons.phone_outlined)),
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: l10n.addressOptional, prefixIcon: const Icon(Icons.location_on_outlined)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _taxIdController,
              decoration: InputDecoration(labelText: l10n.taxIdOptional, prefixIcon: const Icon(Icons.badge_outlined)),
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
                  : Text(_isEditing ? l10n.saveChanges : l10n.saveSupplier),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
