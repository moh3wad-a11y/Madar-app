import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/patient_model.dart';
import '../providers/patient_providers.dart';

/// Returns the selected (or newly created) PatientModel via
/// Navigator.pop, or null if the sheet was dismissed without a
/// selection. Kept intentionally lightweight - full patient management
/// (edit, transaction history, notes) is the Patients tab itself.
class PatientPickerSheet extends ConsumerStatefulWidget {
  const PatientPickerSheet({super.key});

  @override
  ConsumerState<PatientPickerSheet> createState() => _PatientPickerSheetState();
}

class _PatientPickerSheetState extends ConsumerState<PatientPickerSheet> {
  final _searchController = TextEditingController();
  final _newNameController = TextEditingController();
  final _newPhoneController = TextEditingController();
  String _query = '';
  bool _showAddForm = false;
  bool _creating = false;
  String? _addError;

  @override
  void dispose() {
    _searchController.dispose();
    _newNameController.dispose();
    _newPhoneController.dispose();
    super.dispose();
  }

  Future<void> _createAndSelect() async {
    final l10n = AppLocalizations.of(context)!;
    if (_newNameController.text.trim().isEmpty) {
      setState(() => _addError = l10n.requiredField);
      return;
    }
    setState(() {
      _creating = true;
      _addError = null;
    });
    try {
      final repo = ref.read(patientRepositoryProvider);
      final userId = ref.read(authProvider).currentUser?.id ?? 0;
      final created = await repo.create(
        PatientModel(
          name: _newNameController.text.trim(),
          phone: _newPhoneController.text.trim().isEmpty ? null : _newPhoneController.text.trim(),
          createdAt: DateTime.now(),
        ),
        userId: userId,
      );
      if (mounted) Navigator.of(context).pop(created);
    } catch (e) {
      setState(() => _addError = e.toString());
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final resultsAsync = ref.watch(patientSearchProvider(_query));

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.patientCustomer, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  TextButton.icon(
                    onPressed: () => setState(() {
                      _showAddForm = !_showAddForm;
                      _addError = null;
                    }),
                    icon: Icon(_showAddForm ? Icons.close : Icons.person_add_alt_1_outlined, size: 18),
                    label: Text(_showAddForm ? l10n.cancel : l10n.addPatient),
                  ),
                ],
              ),
              if (_showAddForm) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _newNameController,
                  decoration: InputDecoration(labelText: l10n.fullName),
                  autofocus: true,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _newPhoneController,
                  decoration: InputDecoration(labelText: l10n.phoneOptional),
                  keyboardType: TextInputType.phone,
                ),
                if (_addError != null) ...[
                  const SizedBox(height: 6),
                  Text(_addError!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
                ],
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _creating ? null : _createAndSelect,
                  child: _creating
                      ? const SizedBox(
                          height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10n.savePatient),
                ),
              ] else ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: l10n.searchPatientHint,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: resultsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('${l10n.errorGeneric} ($e)')),
                    data: (patients) => patients.isEmpty
                        ? Center(child: Text(l10n.noPatientsYet))
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: patients.length,
                            itemBuilder: (context, index) {
                              final patient = patients[index];
                              return ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                                title: Text(patient.name),
                                subtitle: patient.phone != null ? Text(patient.phone!) : null,
                                onTap: () => Navigator.of(context).pop(patient),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
