class CreditLedger {
  const CreditLedger({
    required this.totalCredits,
    required this.totalKgLost,
    required this.redeemedCredits,
  });

  final int totalCredits;
  final double totalKgLost;
  final int redeemedCredits;

  int get availableCredits => totalCredits - redeemedCredits;
}
