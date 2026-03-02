enum WeightZone { leanVisit, workingRange, earlyWarning, defenseZone }

const double workingMin = 78.0;
const double workingMax = 80.0;
const double leanVisit = 77.0;
const double earlyWarningMin = 81.0;
const double earlyWarningMax = 82.0;
const double defenseThreshold = 83.0;

WeightZone resolveWeightZone(double weight) {
  if (weight <= leanVisit) return WeightZone.leanVisit;
  if (weight >= workingMin && weight <= workingMax) return WeightZone.workingRange;
  if (weight >= earlyWarningMin && weight <= earlyWarningMax) return WeightZone.earlyWarning;
  return WeightZone.defenseZone;
}

WeightZone weightZoneFromName(String? value) {
  return WeightZone.values.firstWhere(
    (zone) => zone.name == value,
    orElse: () => WeightZone.workingRange,
  );
}
