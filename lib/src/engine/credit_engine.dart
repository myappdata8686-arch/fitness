import 'dart:math';

import '../models/credit_ledger.dart';

class CreditEngine {
  const CreditEngine();

  CreditLedger updateCredits({
    required double previousReferenceWeight,
    required double currentReferenceWeight,
    required CreditLedger currentLedger,
  }) {
    final totalLoss = max(0, previousReferenceWeight - currentReferenceWeight);
    final earnedCredits = totalLoss.floor();

    return CreditLedger(
      totalCredits: earnedCredits,
      totalKgLost: totalLoss,
      redeemedCredits: currentLedger.redeemedCredits,
    );
  }
}
