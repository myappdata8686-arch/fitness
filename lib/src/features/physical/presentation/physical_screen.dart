import 'package:flutter/material.dart';

import 'tabs/physical_journey_tab.dart';
import 'tabs/physical_metrics_tab.dart';
import 'tabs/physical_today_tab.dart';
import 'tabs/physical_week_tab.dart';

class PhysicalScreen extends StatelessWidget {
  const PhysicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Physical'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Today'),
              Tab(text: 'Week'),
              Tab(text: 'Metrics'),
              Tab(text: 'Journey'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            PhysicalTodayTab(),
            PhysicalWeekTab(),
            PhysicalMetricsTab(),
            PhysicalJourneyTab(),
          ],
        ),
      ),
    );
  }
}
