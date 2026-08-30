import 'package:flutter/material.dart';

/// Wraps the app in a widget whose key can be changed to force Flutter to
/// tear down and rebuild the entire subtree - including a brand new
/// Riverpod ProviderContainer. This is needed after a database restore:
/// every provider that has ever cached a query result (doctors, revenue
/// lists, the logged-in user, dashboard numbers...) is now holding data
/// from a database file that no longer exists on disk. Without a full
/// restart, the app would keep showing stale in-memory data until each
/// provider happened to be invalidated individually - fragile and easy
/// to miss one. A full remount is the simple, unambiguous fix.
class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({super.key, required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?._restart();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void _restart() {
    setState(() => _key = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
