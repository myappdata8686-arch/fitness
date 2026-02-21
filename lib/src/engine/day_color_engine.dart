import '../models/daily_log.dart';
import '../models/enums.dart';

class DayColorEngine {
  const DayColorEngine();

  DayColor suggestColor(MorningCheckIn checkIn) {
    final riskScore = _riskScore(checkIn);
    if (riskScore >= 5) {
      return DayColor.red;
    }
    if (riskScore >= 3) {
      return DayColor.yellow;
    }
    return DayColor.green;
  }

  int _riskScore(MorningCheckIn checkIn) {
    var score = 0;

    if (checkIn.sleepQuality <= 2) score += 2;
    if (checkIn.stress == StressLevel.high) score += 2;
    if (checkIn.pain >= 2) score += 2;
    if (checkIn.energy == EnergyLevel.low) score += 2;
    if (checkIn.bloodPressure != null && checkIn.bloodPressure!.isNotEmpty) score += 1;

    return score;
  }
}
