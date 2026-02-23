import 'package:flutter/material.dart';

import '../features/credits/credits_screen.dart';
import '../features/home/home_screen.dart';
import '../features/physical/physical_screen.dart';
import '../features/selfcare/selfcare_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/spiritual/spiritual_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => const RootScaffold(),
      settings: settings,
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    PhysicalScreen(),
    SpiritualScreen(),
    SelfCareScreen(),
    CreditsScreen(),
    SettingsScreen(),
  ];

  static const _tabs = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.fitness_center_outlined),
      selectedIcon: Icon(Icons.fitness_center),
      label: 'Physical',
    ),
    NavigationDestination(
      icon: Icon(Icons.self_improvement_outlined),
      selectedIcon: Icon(Icons.self_improvement),
      label: 'Spiritual',
    ),
    NavigationDestination(
      icon: Icon(Icons.spa_outlined),
      selectedIcon: Icon(Icons.spa),
      label: 'Self-Care',
    ),
    NavigationDestination(
      icon: Icon(Icons.stars_outlined),
      selectedIcon: Icon(Icons.stars),
      label: 'Credits',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: _tabs,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
