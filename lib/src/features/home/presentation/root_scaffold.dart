import 'package:flutter/material.dart';

import '../../physical/presentation/physical_screen.dart';
import '../../selfcare/presentation/selfcare_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../spiritual/presentation/spiritual_screen.dart';
import 'home_screen.dart';

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _index = 0;

  final List<Widget> _screens = const <Widget>[
    HomeScreen(),
    PhysicalScreen(),
    SpiritualScreen(),
    SelfCareScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int index) => setState(() => _index = index),
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Physical'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Spiritual'),
          NavigationDestination(icon: Icon(Icons.spa), label: 'Self-Care'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
