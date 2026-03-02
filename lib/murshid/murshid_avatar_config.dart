import 'package:flutter/material.dart';

class MurshidAvatarConfig {
  const MurshidAvatarConfig({
    required this.outfit,
    required this.auraColor,
  });

  final String outfit;
  final Color auraColor;
}

MurshidAvatarConfig avatarForPhase(int phase) {
  switch (phase) {
    case 0:
    case 1:
      return const MurshidAvatarConfig(outfit: 'Fitted modern suit', auraColor: Color(0xFF1A237E));
    case 2:
      return const MurshidAvatarConfig(outfit: 'Blazer open', auraColor: Color(0xFFFFB74D));
    case 3:
      return const MurshidAvatarConfig(outfit: 'Smart casual', auraColor: Color(0xFFFFD54F));
    default:
      return const MurshidAvatarConfig(outfit: 'Athletic relaxed wear', auraColor: Color(0xFFCFD8DC));
  }
}
