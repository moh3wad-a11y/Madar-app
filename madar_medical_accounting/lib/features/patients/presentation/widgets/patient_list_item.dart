import 'package:flutter/material.dart';
import '../../data/models/patient_model.dart';

class PatientListItem extends StatelessWidget {
  final PatientModel patient;
  final VoidCallback onTap;

  const PatientListItem({super.key, required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.person_outline, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: patient.phone != null && patient.phone!.isNotEmpty ? Text(patient.phone!) : null,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
