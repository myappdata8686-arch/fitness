import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/app_data.dart';
import 'features/home/home_screen.dart';
import 'features/journey/journey_storage.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/physical/physical_screen.dart';
import 'features/rewards/reward_center_screen.dart';
import 'features/selfcare/selfcare_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/spiritual/spiritual_screen.dart';
import 'murshid/murshid_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('appBox');
  await Hive.openBox('calendarBox');
  await Hive.openBox('workoutBox');

  await _ensureSchemaVersion();

  runApp(const AthleticOsApp());
}

Future<void> _ensureSchemaVersion() async {
  final box = Hive.box('appBox');
  const currentVersion = 1;
  final storedVersion = box.get('schema_version') as int?;

  if (storedVersion == null) {
    await box.put('schema_version', currentVersion);
    return;
  }

  if (storedVersion < currentVersion) {
    await _runMigrations(storedVersion, currentVersion);
    await box.put('schema_version', currentVersion);
  }
}

Future<void> _runMigrations(int oldV, int newV) async {
  // Intentionally empty for now. Future schema migrations will be added here.
}

class AthleticOsApp extends StatelessWidget {
  const AthleticOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppData(storage: InMemoryJourneyStorage()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        home: const _RootGate(),
      ),
    );
  }
}

class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppData>();
    if (!app.onboardingComplete) {
      return OnboardingScreen(
        onFinish: (profile) => app.completeOnboarding(profile),
        onSkipAll: app.skipOnboarding,
      );
    }
    return const _HomeShell();
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _currentIndex = 3;
  bool _openCheckInOnPhysical = false;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppData>();

    final screens = [
      const SpiritualScreen(),
      PhysicalScreen(autoOpenCheckIn: _openCheckInOnPhysical),
      SelfCareScreen(
        journeyState: app.journey,
        customHabits: app.settings.customSelfCareItems.map((item) {
          final frequency = switch (item.frequency) {
            CustomSelfCareFrequency.daily => Frequency.daily,
            CustomSelfCareFrequency.weekly => Frequency.weekly,
            CustomSelfCareFrequency.monthly => Frequency.monthly,
          };
          return SelfCareHabit(
            id: item.id,
            title: item.title,
            frequency: frequency,
            requiredPhase: item.requiredPhase,
          );
        }).toList(),
      ),
      HomeScreen(
        data: app.homeOverview,
        showProfileReminder: app.userProfile.hasIncompleteCoreFields,
        onNavigateTab: _onTabTap,
        onEnterToday: () {
          setState(() {
            _openCheckInOnPhysical = app.confirmedDay == DayType.none;
            _currentIndex = 1;
          });
        },
      ),
      RewardCenterScreen(
        journeyState: app.journey,
        customRewards: app.settings.customRewards,
        onRedeem: (rewardId, costSoft, costBig) => app.redeemReward(
          rewardId: rewardId,
          costSoft: costSoft,
          costBig: costBig,
        ),
        onWardrobeRedeem: app.markWardrobeRedeemed,
      ),
      const MurshidScreen(),
      SettingsScreen(app: app),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.self_improvement), label: 'Spiritual'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Physical'),
          NavigationDestination(icon: Icon(Icons.spa), label: 'Self-Care'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.card_giftcard), label: 'Rewards'),
          NavigationDestination(icon: Icon(Icons.flutter_dash), label: 'Murshid'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  void _onTabTap(int value) {
    setState(() {
      _currentIndex = value;
      if (value != 1) {
        _openCheckInOnPhysical = false;
      }
    });
  }
}
