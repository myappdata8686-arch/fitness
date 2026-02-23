import 'package:flutter/material.dart';

import 'core/app_router.dart';
import 'core/theme.dart';

void main() {
  runApp(const AApp());
}

class AApp extends StatelessWidget {
  const AApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/',
    );
  }
}
