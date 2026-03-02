import 'package:flutter/material.dart';

LinearGradient getLevelGradient(int level) {
  switch (level) {
    case 1:
      return const LinearGradient(colors: [Color(0xFF0D1B2A), Color(0xFF3A0CA3)]);
    case 2:
      return const LinearGradient(colors: [Color(0xFF3A0CA3), Color(0xFF1F3A93)]);
    case 3:
      return const LinearGradient(colors: [Color(0xFF1F3A93), Color(0xFF1565C0)]);
    case 4:
      return const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF8D6E63)]);
    default:
      return const LinearGradient(colors: [Color(0xFF4FC3F7), Color(0xFFE3F2FD)]);
  }
}
