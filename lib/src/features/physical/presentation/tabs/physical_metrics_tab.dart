import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PhysicalMetricsTab extends StatelessWidget {
  const PhysicalMetricsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _chartCard('Weight (weekly avg)', <FlSpot>[const FlSpot(1, 98), const FlSpot(2, 96), const FlSpot(3, 95)]),
        _chartCard('Blood Pressure', <FlSpot>[const FlSpot(1, 130), const FlSpot(2, 126), const FlSpot(3, 124)]),
        _chartCard('Waist', <FlSpot>[const FlSpot(1, 38), const FlSpot(2, 37), const FlSpot(3, 36)]),
        _chartCard('Sleep', <FlSpot>[const FlSpot(1, 6.2), const FlSpot(2, 6.8), const FlSpot(3, 7.1)]),
        _colorDistribution(),
      ],
    );
  }

  Widget _chartCard(String title, List<FlSpot> spots) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: LineChart(
                LineChartData(
                  lineBarsData: <LineChartBarData>[LineChartBarData(spots: spots, isCurved: false)],
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorDistribution() {
    return const Card(
      child: ListTile(
        title: Text('Monthly color distribution'),
        subtitle: Text('Green: 14 | Yellow: 9 | Red: 3'),
      ),
    );
  }
}
