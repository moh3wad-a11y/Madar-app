import 'package:flutter/material.dart';

/// Shared confirmation dialog. Every delete action in the app must go
/// through this rather than deleting on a single tap (section 18).
Future<bool> showConfirmDialog(
  BuildContext context, {
  String title = 'Delete this record?',
  String message =
      'This can be reversed by an Owner from the audit log, but it will be removed from all reports immediately.',
  String confirmLabel = 'Delete',
  String cancelLabel = 'Cancel',
  bool isDestructive = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: isDestructive
              ? FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
