import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../providers/patient_providers.dart';
import '../widgets/patient_list_item.dart';
import 'add_edit_patient_screen.dart';
import 'patient_detail_screen.dart';

class PatientListScreen extends ConsumerStatefulWidget {
  const PatientListScreen({super.key});

  @override
  ConsumerState<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends ConsumerState<PatientListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final patientsAsync = ref.watch(patientSearchProvider(_query));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.patientsTitle)),
      floatingActionButton: RoleGate(
        permission: Permission.managePatients,
        child: FloatingActionButton(
          onPressed: () async {
            final saved = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => const AddEditPatientScreen()),
            );
            if (saved == true) ref.invalidate(patientSearchProvider);
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchPatientHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(patientSearchProvider),
              child: patientsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ListView(
                  children: [const SizedBox(height: 60), Center(child: Text('${l10n.errorGeneric} ($e)'))],
                ),
                data: (patients) => patients.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 40),
                          EmptyState(icon: Icons.people_outline, title: l10n.noPatientsYet),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return PatientListItem(
                            patient: patient,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => PatientDetailScreen(patient: patient)),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
