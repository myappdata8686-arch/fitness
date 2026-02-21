import 'package:flutter/material.dart';

class AthleticForLifeApp extends StatelessWidget {
  const AthleticForLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    const emerald = Color(0xFF10B981);
    const gold = Color(0xFFD4AF37);

    return MaterialApp(
      title: 'Athletic For Life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F14),
        colorScheme: const ColorScheme.dark(
          primary: emerald,
          secondary: gold,
          surface: Color(0xFF121821),
        ),
        useMaterial3: true,
      ),
      home: const _DashboardScreen(),
    );
  }
}

class _DashboardScreen extends StatelessWidget {
  const _DashboardScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Athletic For Life')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _CardTile(
            title: 'Morning State',
            subtitle: 'Assess sleep, stress, pain, and energy. Override remains in your control.',
          ),
          _CardTile(
            title: 'Daily Protocol',
            subtitle: 'Red protects, Yellow maintains, Green progresses. No punishment language.',
          ),
          _CardTile(
            title: 'Weekly Integrity',
            subtitle: '80%+ is successful; adaptive threshold applies during illness or high stress.',
          ),
          _CardTile(
            title: 'Credits & Rewards',
            subtitle: '1 kg lost = 1 upgrade credit. Redeem manually for meaningful upgrades.',
          ),
        ],
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
