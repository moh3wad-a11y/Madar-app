import 'package:flutter/material.dart';
import '../../data/models/doctor_model.dart';

class DoctorListItem extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const DoctorListItem({super.key, required this.doctor, required this.onTap});

  String get _commissionLabel {
    switch (doctor.commissionType) {
      case 'percentage':
        return '${doctor.commissionValue.toStringAsFixed(0)}% commission';
      case 'fixed':
        return '${doctor.commissionValue.toStringAsFixed(0)} EGP fixed per visit';
      default:
        return 'No commission';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.medical_services_outlined, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          [if (doctor.specialty != null && doctor.specialty!.isNotEmpty) doctor.specialty!, _commissionLabel]
              .join(' · '),
        ),
        trailing: !doctor.isActive
            ? Chip(
                label: const Text('Inactive', style: TextStyle(fontSize: 11)),
                visualDensity: VisualDensity.compact,
                backgroundColor: theme.colorScheme.errorContainer,
              )
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}
