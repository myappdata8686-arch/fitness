class AnalyticsEngine {
  const AnalyticsEngine();

  List<double> movingAverageWeight(List<double> weeklyWeights, {int window = 3}) {
    if (weeklyWeights.isEmpty) return [];

    final result = <double>[];
    for (var i = 0; i < weeklyWeights.length; i++) {
      final start = (i - window + 1).clamp(0, i);
      final slice = weeklyWeights.sublist(start, i + 1);
      final avg = slice.reduce((a, b) => a + b) / slice.length;
      result.add(double.parse(avg.toStringAsFixed(2)));
    }
    return result;
  }

  Map<String, int> colorDistribution(List<String> colors) {
    final distribution = {'red': 0, 'yellow': 0, 'green': 0};
    for (final color in colors) {
      if (distribution.containsKey(color)) {
        distribution[color] = distribution[color]! + 1;
      }
    }
    return distribution;
  }
}
