import 'dart:math';

enum ProfileWeightUnit { kg, lb }
enum ProfileHeightUnit { ftIn, cm }
enum ProfileMeasurementUnit { inches, cm }

class UserUnitPreferences {
  UserUnitPreferences({
    this.weightUnit = ProfileWeightUnit.kg,
    this.heightUnit = ProfileHeightUnit.ftIn,
    this.measurementUnit = ProfileMeasurementUnit.inches,
  });

  ProfileWeightUnit weightUnit;
  ProfileHeightUnit heightUnit;
  ProfileMeasurementUnit measurementUnit;
}

class UserProfile {
  UserProfile({
    this.name,
    this.gender = 'male',
    this.age,
    this.weightKg,
    this.waistCm,
    this.chestCm,
    this.hipsCm,
    this.neckCm,
    this.heightCm,
    this.targetWeightKg,
    UserUnitPreferences? units,
    this.isProfileComplete = false,
  }) : units = units ?? UserUnitPreferences();

  String? name;
  String gender;
  int? age;

  double? weightKg;
  double? waistCm;
  double? chestCm;
  double? hipsCm;
  double? neckCm;
  double? heightCm;

  double? targetWeightKg;

  UserUnitPreferences units;
  bool isProfileComplete;

  void recomputeCompleteness() {
    isProfileComplete = age != null && weightKg != null && heightCm != null && targetWeightKg != null;
  }

  bool get hasIncompleteCoreFields => !isProfileComplete;
}

double toKg(double value, ProfileWeightUnit unit) => unit == ProfileWeightUnit.kg ? value : value / 2.20462;
double fromKg(double value, ProfileWeightUnit unit) => unit == ProfileWeightUnit.kg ? value : value * 2.20462;

double toCmFromHeight(double value, ProfileHeightUnit unit) => unit == ProfileHeightUnit.cm ? value : value * 30.48;
double fromCmToHeight(double value, ProfileHeightUnit unit) => unit == ProfileHeightUnit.cm ? value : value / 30.48;

double toCmMeasure(double value, ProfileMeasurementUnit unit) => unit == ProfileMeasurementUnit.cm ? value : value * 2.54;
double fromCmMeasure(double value, ProfileMeasurementUnit unit) => unit == ProfileMeasurementUnit.cm ? value : value / 2.54;

bool isRealisticWeightKg(double kg) => kg > 30 && kg < 200;
bool isRealisticHeightCm(double cm) => cm > 120 && cm < 230;

double safeRound(double value) => (value * 10).roundToDouble() / 10;
int clampAge(int age) => max(0, min(age, 120));
