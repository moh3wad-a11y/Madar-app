import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle statValue = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);

  static const TextStyle statLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  static const TextStyle sectionTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  static const TextStyle tableHeader = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.grey,
  );

  static const TextStyle tableCell = TextStyle(fontSize: 13, fontWeight: FontWeight.w400);
}
