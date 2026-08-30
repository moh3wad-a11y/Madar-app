import 'package:flutter/material.dart';
import '../../data/models/supplier_model.dart';

class SupplierListItem extends StatelessWidget {
  final SupplierModel supplier;
  final VoidCallback onTap;

  const SupplierListItem({super.key, required this.supplier, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.local_shipping_outlined, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(supplier.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: supplier.phone != null && supplier.phone!.isNotEmpty ? Text(supplier.phone!) : null,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
