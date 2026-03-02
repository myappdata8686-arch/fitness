class MealEstimate {
  const MealEstimate({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final int calories;
  final int protein;
  final int carbs;
  final int fat;
}

class MurshidMealParser {
  MealEstimate parseOffline(String text) {
    final lower = text.toLowerCase();
    var calories = 300;
    var protein = 15;
    var carbs = 35;
    var fat = 10;

    if (lower.contains('chicken')) {
      protein += 20;
      calories += 120;
    }
    if (lower.contains('rice')) {
      carbs += 40;
      calories += 180;
    }
    if (lower.contains('oil') || lower.contains('fried')) {
      fat += 15;
      calories += 140;
    }

    return MealEstimate(calories: calories, protein: protein, carbs: carbs, fat: fat);
  }
}
