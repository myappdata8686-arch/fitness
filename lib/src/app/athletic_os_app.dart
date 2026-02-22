import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/home/presentation/root_scaffold.dart';

class AthleticOsApp extends StatelessWidget {
  const AthleticOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athletic OS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const RootScaffold(),
    );
  }
}
