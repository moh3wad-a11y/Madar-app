import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/restart_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RestartWidget(child: ProviderScope(child: MadarApp())));
}
