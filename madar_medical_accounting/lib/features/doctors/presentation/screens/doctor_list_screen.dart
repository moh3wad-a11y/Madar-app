import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../providers/doctor_providers.dart';
import '../widgets/doctor_list_item.dart';
import 'add_edit_doctor_screen.dart';
import 'doctor_detail_screen.dart';

class DoctorListScreen extends ConsumerWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final doctorsAsync = ref.watch(allDoctorsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.doctorsTitle)),
      floatingActionButton: RoleGate(
        permission: Permission.manageDoctors,
        child: FloatingActionButton(
          onPressed: () async {
            final saved = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => const AddEditDoctorScreen()),
            );
            if (saved == true) {
              ref.invalidate(allDoctorsProvider);
              ref.invalidate(activeDoctorsProvider);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(allDoctorsProvider),
        child: doctorsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            children: [const SizedBox(height: 60), Center(child: Text('${l10n.errorGeneric} ($e)'))],
          ),
          data: (doctors) => doctors.isEmpty
              ? ListView(
                  children: [
                    const SizedBox(height: 40),
                    EmptyState(icon: Icons.medical_services_outlined, title: l10n.noDataFound),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return DoctorListItem(
                      doctor: doctor,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => DoctorDetailScreen(doctor: doctor)),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
