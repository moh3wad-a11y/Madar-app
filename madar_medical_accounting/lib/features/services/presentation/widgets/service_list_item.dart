import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/models/service_model.dart';

class ServiceListItem extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceListItem({super.key, required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.medical_information_outlined, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(service.category?.isNotEmpty == true ? service.category! : 'Uncategorized'),
        trailing: Text(
          CurrencyFormatter.format(service.price),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
